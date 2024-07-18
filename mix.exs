defmodule CLIChat.MixProject do
  use Mix.Project

  def project do
    [
      app: :cli_chat,
      version: "0.1.0",
      elixir: "~> 1.18-dev",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {CLIChat.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end
end
