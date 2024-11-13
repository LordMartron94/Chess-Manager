defmodule ComponentRegistration do
  @moduledoc """
    This module provides functionality to register this component to the middleman router.
  """
  def register() do
    case(TCPClient.start(~c"127.0.0.1", 50000)) do
      {:ok, socket} ->
        register_component(socket, "<eom>")
        ComponentRegistration.KeepAlive.start_link(socket, "<eom>", 5000)
      :error -> IO.puts("Error connecting.")
    end
  end

  defp register_component(socket, delimiter) do
    IO.puts("Registering component...")

    case(MessageHandler.get_full_message_from_json("priv/registration.json")) do
      {:ok, contents} ->
        TCPClient.send_message(socket, contents, delimiter)

      :error -> IO.puts("Error reading registration message.")
    end
  end
end
