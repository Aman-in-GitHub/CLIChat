defmodule CLIChatTest do
  use ExUnit.Case
  doctest CLIChat

  test "greets the world" do
    assert CLIChat.init() == :ok
  end
end
