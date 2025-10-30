defmodule Mix.Tasks.Sup.Tree do
  use Mix.Task

  @shortdoc "Prints supervision trees"

  @moduledoc """
  **#{@shortdoc}**

  ### Example usage:

      $ mix sup.tree mix
      Mix 
      └── Mix.Supervisor 
          ├── Mix.PubSub 
          │   ├── Mix.PubSub.ListenerSupervisor 
          │   └── Mix.PubSub.Subscriber 
          ├── Mix.ProjectStack 
          ├── Mix.TasksServer 
          ├── Mix.State 
          └── Mix.Sync.PubSub 

  """

  @requirements ["app.start"]

  def run([]) do
    app = to_string(Keyword.get(Mix.Project.config(), :app))
    run([app])
  end

  def run(args) do
    :application_controller.info()
    |> Keyword.get(:running, [])
    |> Enum.filter(fn {_app_name, pid} -> is_pid(pid) end)
    |> Enum.filter(fn {app_name, _pid} -> args == ["--all"] || to_string(app_name) in args end)
    |> Enum.map(fn {app_name, pid} -> {pid, app_name, :application_controller} end)
    |> Mix.Utils.print_tree(&node(&1, registry_map()))
  end

  defp node({pid, app_name, :application_controller}, _registry) do
    {pid, module} = :application_master.get_child(pid)

    {{"#{IO.ANSI.bright()}" <> inspect(module || app_name) <> "#{IO.ANSI.reset()}", ""},
     [{pid, :supervisor}]}
  end

  defp node({pid, :supervisor}, registry) do
    {format(pid, registry), children(pid)}
  end

  defp node({pid, :worker}, registry) do
    {format(pid, registry), []}
  end

  defp children(supervisor) do
    supervisor
    |> Supervisor.which_children()
    |> Enum.filter(fn {_id, child, _type, _modules} -> is_pid(child) end)
    |> Enum.map(fn {_id, child, type, _modules} -> {child, type} end)
  end

  defp registry_map do
    Process.registered()
    |> Enum.map(fn name -> {Process.whereis(name), name} end)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
  end

  defp format(pid, registry) do
    cond do
      Map.has_key?(registry, pid) ->
        {Enum.join(Enum.map(registry[pid], &inspect/1), ","), ""}

      true ->
        {"#{IO.ANSI.faint()}" <> inspect(pid) <> "#{IO.ANSI.reset()}", ""}
    end
  end
end
