defmodule ChessManagerTest do
  use ExUnit.Case
  doctest ChessManager

  test "greets the world" do
    assert ChessManager.hello() == :world
  end
end
