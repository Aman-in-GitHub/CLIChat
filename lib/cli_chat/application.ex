defmodule CLIChat.Application do
  @moduledoc """
  Documentation for `CLIChat.Application`
  """

  use Application

  @impl true
  def start(_type, _args) do
    CLIChat.init()

    port = String.to_integer(System.get_env("PORT") || "9696")

    children = [
      {Task.Supervisor, name: TCP.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> CLIChat.TCP.accept_port(port) end}, restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: CLIChat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
