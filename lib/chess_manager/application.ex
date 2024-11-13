defmodule ChessManager.Application do
  use Application

  def start(_type, _args) do
    Process.flag(:trap_exit, true)

    ChessManager.start(nil, nil)
    {:ok, self()}
  end
end