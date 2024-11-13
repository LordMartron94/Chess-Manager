defmodule MessageHandler do
  @moduledoc """
  Helper module for message-related functionality.
  """

  def get_full_message_from_json(json_path) do
    case(JSONHandler.read_json_from_file(json_path)) do
      nil ->
        IO.puts("Error reading registration data.")
        :error
      contents ->
        data = MessageHandler.add_metadata(contents)
        IO.puts("Registration data successfully read.")
        {:ok, data}
    end
  end

  def get_raw_message_from_json(json_path) do
    case(JSONHandler.read_json_from_file(json_path)) do
      nil ->
        IO.puts("Error reading registration data.")
        :error
      data ->
        IO.puts("Registration data successfully read.")
        {:ok, data}
    end
  end

  def add_metadata(data) do
    time_sent = DateTime.utc_now() |> RFC3339.to_rfc3339()
    unique_id = UUID.uuid4() |> to_string()

    Map.put(data, "time_sent", time_sent)
    |> Map.put("unique_id", unique_id)
  end
end
