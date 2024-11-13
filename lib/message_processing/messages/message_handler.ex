defmodule MessageHandler do
  @moduledoc """
  Helper module for message-related functionality.
  """

  def decode_message(message_string) do
    message = Poison.decode!(message_string, as: %Message{
      payload: %Payload{
        args: [%PayloadArgs{}]
      }
    })

    message
  end

  def encode_message(message) do
    message_json = Poison.encode!(message)
    message_json
  end

  def get_full_message_from_json(json_path) do
    case(JSONHandler.read_json_from_file(json_path)) do
      nil ->
        IO.puts("Error reading data.")
        :error
      contents ->
        data = MessageHandler.add_metadata(contents)
        IO.puts("Data successfully read.")
        {:ok, data}
    end
  end

  def get_raw_message_from_json(json_path) do
    case(JSONHandler.read_json_from_file(json_path)) do
      nil ->
        IO.puts("Error reading raw data.")
        :error
      data ->
        IO.puts("Raw data successfully read.")
        {:ok, data}
    end
  end

  def construct_basic_message(action) do
    case(JSONHandler.read_json_from_file("priv/default_request.json")) do
      nil ->
        IO.puts("Error reading registration data.")
        :error
      data ->
        added_data = add_metadata(data)
        payload = %{"action" => action, "args" => nil}
        final_data = add_payload(added_data, payload)
        {:ok, final_data}
    end
  end

  defp add_payload(data, payload) do
    Map.put(data, "payload", payload)
  end

  def add_metadata(data) do
    time_sent = DateTime.utc_now() |> RFC3339.to_rfc3339()
    unique_id = UUID.uuid4() |> to_string()

    Map.put(data, "time_sent", time_sent)
    |> Map.put("unique_id", unique_id)
  end
end
