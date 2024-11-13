defmodule PayloadArgs do
  @derive Poison.Encoder
  defstruct [:type, :value]
end

defmodule Payload do
  @derive Poison.Encoder
  defstruct [:action, :args]

  def create(action, args) when is_list(args) do
    %Payload{action: action, args: Enum.map(args, &create_arg/1)}
  end

  defp create_arg({type, value}) do
    %PayloadArgs{type: type, value: value}
  end
end

defmodule Message do
  @derive Poison.Encoder
  defstruct [:requester_id, :time_sent, :payload, :unique_id]
end