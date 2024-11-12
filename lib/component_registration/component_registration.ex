defmodule ComponentRegistration do
  @moduledoc """
    This module provides functionality to register this component to the middleman router.
  """
  def register() do
    case(TCPClient.start(~c"127.0.0.1", 50000)) do
      {:ok, socket} -> register_component(socket)
      :error -> IO.puts("Error connecting.")
    end
  end

  defp register_component(socket) do
    IO.puts("Registering component...")

    case(JSONHandler.read_json_from_file("priv/registration.json")) do
      nil -> IO.puts("Error reading registration data.")
      contents ->
        data = add_metadata(contents)
        bytes = JSONHandler.to_bytes(data, "<eom>")
        IO.puts("Sending message: #{bytes}")
        :gen_tcp.send(socket, bytes)
    end
  end

  defp add_metadata(data) do
    time_sent = DateTime.utc_now() |> RFC3339.to_rfc3339()
    unique_id = UUID.uuid4() |> to_string()

    Map.put(data, "time_sent", time_sent)
    |> Map.put("unique_id", unique_id)
  end
end
