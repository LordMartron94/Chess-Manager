defmodule RFC3339 do
  def to_rfc3339(datetime) do
    datetime
    |> DateTime.to_iso8601(:extended)
    |> String.replace(~r"{(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3})\d+Z}", "\\1Z")
  end
end