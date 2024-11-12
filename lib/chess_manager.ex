defmodule ChessManager do
  @moduledoc """
  Main module.
  """

  def start(_type, _args) do
    IO.puts("Starting ChessManager...")
    test()
    {:ok, self()}
  end

  def test() do
    IO.puts "Testing ChessManager module"
    ComponentRegistration.register()
  end
end
