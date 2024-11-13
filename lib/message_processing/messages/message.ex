defmodule PayloadArgs do
  @derive Poison.Encoder
  defstruct [:type, :value]
end

defmodule Payload do
  @derive Poison.Encoder
  defstruct [:action, :args]
end

defmodule Message do
  @derive Poison.Encoder
  defstruct [:requester_id, :time_sent, :payload, :unique_id]
end