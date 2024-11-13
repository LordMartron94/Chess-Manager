defmodule ComponentRegistration do
  @moduledoc """
    This module provides functionality to register this component to the middleman router.
  """
  def register(shutdown_listener_pid) do
    delimiter = "<eom>"

    case(TCPClient.start(~c"127.0.0.1", 50000)) do
      {:ok, socket} ->
        register_component(socket, delimiter)
        read_loop_pid = spawn(fn -> TCPClient.read_loop(socket, delimiter, shutdown_listener_pid) end)
        keep_alive_pid = ComponentRegistration.KeepAlive.start_link(socket, delimiter, 30000)
        {:ok, keep_alive_pid, read_loop_pid, socket}
      :error ->
        IO.puts("Error connecting.")
        {:error, "There was an error connecting to the client."}
    end
  end

  defp register_component(socket, delimiter) do
    IO.puts("Registering component...")

    case(MessageHandler.get_full_message_from_json("priv/registration.json")) do
      {:ok, contents} ->
        case(MessageHandler.insert_component_signature(contents)) do
          :error ->
            IO.puts("Error inserting component signature")
            :error
          {:ok, full_data} ->
            TCPClient.send_request(socket, full_data, delimiter)
        end

      :error -> IO.puts("Error reading registration message.")
    end
  end

  def shutdown(socket, keep_alive_pid, read_loop_pid) do
    send(keep_alive_pid, :stop)
    send(read_loop_pid, :stop)

    case(MessageHandler.construct_basic_message("unregister")) do
      {:ok, contents} ->
        TCPClient.send_request(socket, contents, "<eom>")

      :error -> IO.puts("Error constructing unregister message.")
    end

    TCPClient.close_socket(socket)
  end
end
