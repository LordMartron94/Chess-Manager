defmodule ChessManager do
  @moduledoc """
  Main module.
  """

  def start(_type, _args) do
    IO.puts("Starting ChessManager...")

    case ComponentRegistration.register(self()) do
      {:ok, keep_alive_pid, read_loop_pid, socket} ->
        IO.puts("Component registration successful.")
        HoornLogger.info(socket, "Successfully launched.")
        listen_for_shutdown_loop(socket, keep_alive_pid, read_loop_pid)
      {:error, reason} ->
        IO.puts("Component registration failed: #{reason}")
        :ok
    end

    {:ok, self()}
  end

  defp listen_for_shutdown_loop(socket, keep_alive_pid, read_loop_pid) do
    receive do
      :app_shutdown ->
        ComponentRegistration.shutdown(socket, keep_alive_pid, read_loop_pid)
    end
  end
end