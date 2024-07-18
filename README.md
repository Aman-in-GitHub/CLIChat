# CLIChat

A CLI based chat application made in Elixir using the [:gen_tcp](https://www.erlang.org/doc/apps/kernel/gen_tcp.html) module

## Installation

- Make sure you have Erlang and Elixir installed in your system.
- Clone this Git repository: `git clone https://github.com/Aman-in-GitHub/CLIChat`
- Change into the project directory: `cd CLIChat`
- Run `mix deps.get` to install dependencies
- Run `mix run --no-halt` to start your CLIChat
- Run `telnet 127.0.0.1 9696` to connect to the chat room

## Features

- **Client Management:** Accepts multiple client connections and assigns each a unique username.

- **Client Notification:** Notifies all clients when a new client joins or leaves the chat room.

- **Robust Error Handling:** Implements error handling for various scenarios, ensuring smooth operation even when exceptions occur.

- **Real-time Communication:** Utilizes TCP sockets to facilitate real-time chat functionality.

- **Task Supervision:** Leverages Task Supervisor to manage client-specific tasks efficiently.

- **Dynamic Interaction:** Continuously accepts new clients and processes messages without requiring a server restart.
