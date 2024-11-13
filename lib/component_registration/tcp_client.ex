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

  def close_socket(socket) do
    :gen_tcp.close(socket)
    IO.puts "Connection closed"
  end

  def send_request(socket, request_data, delimiter) do
    bytes = JSONHandler.to_bytes(request_data, delimiter)
    :gen_tcp.send(socket, bytes)
    end

  def read_loop(socket, delimiter, shutdown_listener_pid) do
    # State for accumulating data and the message queue
    state = %{buffer: <<>>, queue: :queue.new()}

    read_loop(socket, delimiter, state, &MessageProcessor.process_message/2, shutdown_listener_pid)
  end

  defp read_loop(socket, delimiter, state, message_processor, shutdown_listener_pid) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        new_buffer = state.buffer <> data

        {messages, remaining_buffer} = extract_messages(new_buffer, delimiter, [])

        new_queue = Enum.reduce(messages, state.queue, fn message, queue ->
          :queue.in(message, queue)
        end)

        {new_queue, processed_count} = process_messages(new_queue, 0, message_processor, shutdown_listener_pid)

        read_loop(socket, delimiter, %{buffer: remaining_buffer, queue: new_queue}, message_processor, shutdown_listener_pid)

      {:error, reason} ->
        IO.puts("Error receiving data: #{reason}")
    end
  end

  defp extract_messages(buffer, delimiter, messages) do
    case :binary.split(buffer, delimiter) do
      [message, rest] ->
        extract_messages(rest, delimiter, [message | messages])
      [remaining] ->
        {Enum.reverse(messages), remaining}
    end
  end

  defp process_messages(queue, processed_count, message_processor, shutdown_listener_pid) do
    case :queue.out(queue) do
      {{:value, message}, new_queue} ->
        processed_message = MessageHandler.decode_message(message)
        message_processor.(processed_message, shutdown_listener_pid)

        process_messages(new_queue, processed_count + 1, message_processor, shutdown_listener_pid)
      _ ->
        {queue, processed_count}
    end
  end
end