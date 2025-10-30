# SupTree

Mix task to visualize supervision trees.

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


When run without argument, it prints the tree of the current projects app. Use
`--all` to print the supervision trees of all running apps.


## Installation

    mix archive.install hex sup_tree

