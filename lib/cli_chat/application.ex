defmodule CLIChat.Application do
  @moduledoc """
  Documentation for `CLIChat.Application`
  """
  use Application

  @impl true
  def start(_type, _args) do
    children = []

    opts = [strategy: :one_for_one, name: CLIChat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
