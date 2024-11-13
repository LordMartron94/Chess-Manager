defmodule ComponentRegistration.KeepAlive do
  def start_link(socket, delimiter, interval) do
    spawn(fn -> loop(socket, delimiter, interval) end)
  end

  defp loop(socket, delimiter, interval) do
    receive do
      :stop ->
        IO.puts("Stopping keep-alive loop...")
    after
      interval ->
        case(MessageHandler.construct_basic_message("keep_alive")) do
          {:ok, data} ->
            TCPClient.send_request(socket, data, delimiter)
          :error ->
            IO.puts("Error constructing keep-alive message")
        end

        loop(socket, delimiter, interval)
    end
  end
end