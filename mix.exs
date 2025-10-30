defmodule SupTree.MixProject do
  use Mix.Project

  def project do
    [
      app: :sup_tree,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps()
    ]
  end

  defp package() do
    [
      description: "A Mix.Task that prints the supervision tree of your app to the terminal",
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/bsanyi/sup_tree"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
