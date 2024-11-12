defmodule JSONHandler do
  def read_json_from_file(file_path) do
    case File.read(file_path) do
      {:ok, contents} ->
        Poison.decode!(contents)

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
        nil
    end
  end

  def to_bytes(data, delimiter) do
    Poison.encode!(data) <> delimiter
  end
end