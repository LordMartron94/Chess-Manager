defmodule ComponentRegistration.KeepAlive do
  def start_link(socket, delimiter, interval) do
    case(MessageHandler.get_raw_message_from_json("priv/keep_alive.json")) do
      {:ok, raw_data} ->
        spawn(fn -> loop(socket, raw_data, delimiter, interval) end)
      :error ->
        IO.puts("Error retrieving keep-alive data")
    end
  end

  defp loop(socket, raw_data, delimiter, interval) do
    data = MessageHandler.add_metadata(raw_data)
    TCPClient.send_message(socket, data, delimiter)
    Process.sleep(interval)
    loop(socket, raw_data, delimiter, interval)
  end
end