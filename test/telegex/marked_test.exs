defmodule Telegex.MarkedTest do
  use ExUnit.Case
  doctest Telegex.Marked

  test "greets the world" do
    assert Telegex.Marked.hello() == :world
  end
end
