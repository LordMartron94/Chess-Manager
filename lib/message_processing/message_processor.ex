defmodule MessageProcessor do
  @moduledoc """
This is a module to process messages.
"""
  def process_message(message, shutdown_listener_pid) do
    action = message.payload.action

    case action do
      "shutdown" ->
        handle_shutdown_message(shutdown_listener_pid)
      _ -> IO.puts("Unknown action: #{action}")
    end
  end

  defp handle_shutdown_message(shutdown_listener_pid) do
    IO.puts("Received shutdown message")
    send(shutdown_listener_pid, :app_shutdown)
  end

end