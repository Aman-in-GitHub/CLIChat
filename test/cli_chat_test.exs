defmodule CLIChatTest do
  use ExUnit.Case
  doctest CLIChat

  test "greets the world" do
    assert CLIChat.hello() == :ok
  end
end
