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

  def insert_component_signature(data) do
    case(get_raw_message_from_json("priv/component_signature.json")) do
      :error ->
        IO.puts("Error reading component signature.")
        :error
      {:ok, signature_data} ->
        # 4. Append to the message (using the `++` operator to add a single-element list)
        encoded = Poison.encode!(signature_data)
        updated_message = update_in(data, ["payload", "args"], &(&1 ++ [%{"type" => "list", "value" => encoded}]))
        {:ok, updated_message}
    end
  end

  defp get_default_request() do
    case(JSONHandler.read_json_from_file("priv/default_request.json")) do
      nil ->
        IO.puts("Error reading registration data.")
        :error
      data ->
        added_data = add_metadata(data)
        {:ok, added_data}
    end
  end

  def construct_basic_message(action) do
    case(get_default_request()) do
      :error ->
        IO.puts("Error constructing basic message.")
        :error
      {_, data} ->
        payload = %Payload{
          args: [%PayloadArgs{}],
          action: action
        }
        basic_message = add_payload(data, payload)
        {:ok, basic_message}
    end
  end

  defp add_payload(data, payload) do
    Map.put(data, "payload", payload)
  end

  def construct_advanced_message(payload) do
    case(get_default_request()) do
      :error ->
        IO.puts("Error constructing advanced message.")
        :error
      {_, data} ->
        advanced_message = add_payload(data, payload)
        advanced_message
    end
  end

  def add_metadata(data) do
    time_sent = DateTime.utc_now() |> RFC3339.to_rfc3339()
    unique_id = UUID.uuid4() |> to_string()

    Map.put(data, "time_sent", time_sent)
    |> Map.put("unique_id", unique_id)
  end
end
