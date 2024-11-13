defmodule ChessManager do
  @moduledoc """
  Main module.
  """

  def start(_type, _args) do
    IO.puts("Starting ChessManager...")
    ComponentRegistration.register()

    loop()
    {:ok, self()}
  end

  defp loop do
    loop()
  end
end
