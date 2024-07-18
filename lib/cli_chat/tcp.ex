defmodule CLIChat.TCP do
  @moduledoc """
  Documentation for `CLIChat.TCP`
  """

  alias CLIChat.Registry

  require Logger

  def accept_port(port) do
    {:ok, _pid} = Registry.start_link([])

    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Accepting clients at PORT: #{port} | Socket: #{inspect(socket)}")

    client_acceptor(socket)
  end

  defp client_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)

    :gen_tcp.send(
      client,
      "Welcome to the chat room: #{inspect(socket)}\nEnter your username to continue: "
    )

    {:ok, name} = :gen_tcp.recv(client, 0)
    name = String.trim(name)

    Logger.info("New client connected: #{inspect(client)}")

    Registry.add_client(:registry, client)

    all_clients =
      Registry.get_all_clients(:registry)

    :gen_tcp.send(client, "Chat members count: #{length(all_clients)}\n")

    time_now = Time.utc_now() |> Time.to_string()

    Enum.each(all_clients, fn user ->
      :gen_tcp.send(user, "~ #{name} joined the room at #{time_now} ~\n")

      if length(all_clients) === 1 do
        :gen_tcp.send(user, "Waiting for someone else to join\n")
      end
    end)

    {:ok, pid} = Task.Supervisor.start_child(TCP.TaskSupervisor, fn -> serve({client, name}) end)
    :ok = :gen_tcp.controlling_process(client, pid)

    client_acceptor(socket)
  end

  defp serve({socket, name}) do
    try do
      socket
      |> read_line()
      |> write_line(socket, name)

      serve({socket, name})
    rescue
      _ ->
        Logger.alert("Client #{inspect(socket)} disconnected")

        Registry.remove_client(:registry, socket)

        all_clients =
          Registry.get_all_clients(:registry)

        time_now = Time.utc_now() |> Time.to_string()

        Enum.each(all_clients, fn user ->
          :gen_tcp.send(user, "~ #{name} left the chat room at #{time_now} ~\n")

          :gen_tcp.send(user, "Chat members count: #{length(all_clients)}\n")

          if length(all_clients) === 1 do
            :gen_tcp.send(user, "Waiting for someone else to join\n")
          end
        end)
    end
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_line(data, socket, name) do
    all_clients =
      Registry.get_all_clients(:registry)
      |> Enum.filter(fn client ->
        client != socket
      end)

    if length(all_clients) === 0 do
      :gen_tcp.send(socket, "Please wait for someone else to join the room\n")
    else
      msg = "#{name} - #{data}"

      Enum.each(all_clients, fn user ->
        :gen_tcp.send(user, msg)
      end)
    end
  end
end
