defmodule CLIChat.Registry do
  @moduledoc """
  Documentation for `CLIChat.Registry`
  """

  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: :registry)
  end

  def get_all_clients(pid) do
    GenServer.call(pid, {:get})
  end

  def add_client(pid, client) do
    GenServer.cast(pid, {:add, client})
  end

  def remove_client(pid, client) do
    GenServer.cast(pid, {:remove, client})
  end

  @impl true
  def init(list) do
    {:ok, list}
  end

  @impl true
  def handle_call({:get}, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:add, client}, state) do
    new_state = [client | state]
    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:remove, client}, state) do
    new_state = List.delete(state, client)
    {:noreply, new_state}
  end
end
