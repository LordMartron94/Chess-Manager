defmodule ChessManager.Application do
  use Application

  def start(_type, _args) do
    ChessManager.start(nil, nil)
    {:ok, self()}
  end
end