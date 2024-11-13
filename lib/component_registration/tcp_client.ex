defmodule TCPClient do
  def start(host, port) do
    case :gen_tcp.connect(host, port, [:binary, active: false]) do
      {:ok, socket} ->
        IO.puts "Connected to #{host}:#{port}"
        {:ok, socket}

      {:error, reason} ->
        IO.puts "Connection failed: #{reason}"
        :error
    end
  end

  def send_message(socket, data, delimiter) do
    bytes = JSONHandler.to_bytes(data, delimiter)
    IO.puts("Sending message: #{bytes}")
    :gen_tcp.send(socket, bytes)
    end
end