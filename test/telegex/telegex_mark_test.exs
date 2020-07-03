defmodule Telegex.MarkTest do
  use ExUnit.Case
  doctest Telegex.Mark

  test "greets the world" do
    assert Telegex.Mark.hello() == :world
  end
end
