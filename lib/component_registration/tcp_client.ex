defmodule TCPClient do
  def start(host, port, _shutdown_listener_pid) do
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

  def send_message(socket, data, delimiter) do
    bytes = JSONHandler.to_bytes(data, delimiter)
    IO.puts("Sending message: #{bytes}")
    :gen_tcp.send(socket, bytes)
    end

  def read_loop(socket, delimiter) do
    # State for accumulating data and the message queue
    state = %{buffer: <<>>, queue: :queue.new()}

    read_loop(socket, delimiter, state)
  end

  defp read_loop(socket, delimiter, state) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        # Add new data to the buffer
        new_buffer = state.buffer <> data

        # Split messages based on the delimiter
        {messages, remaining_buffer} = extract_messages(new_buffer, delimiter, [])

        # Enqueue the extracted messages
        new_queue = Enum.reduce(messages, state.queue, fn message, queue ->
          :queue.in(message, queue)
        end)

        # Process messages from the queue with acknowledgement
        {new_queue, processed_count} = process_messages(new_queue, 0)

        # Print the number of processed messages (optional)
        IO.puts("Processed #{processed_count} new messages.")

        # Continue the loop with the remaining buffer and updated queue
        read_loop(socket, delimiter, %{buffer: remaining_buffer, queue: new_queue})

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

  defp process_messages(queue, processed_count) do
    case :queue.out(queue) do
      {{:value, message}, new_queue} ->
        IO.puts("Processing message: #{inspect(message)}")
        process_messages(new_queue, processed_count + 1) # Increment count
      _ ->
        {queue, processed_count}  # Return the queue and count
    end
  end
end