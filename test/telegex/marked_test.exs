defmodule Telegex.MarkedTest do
  use ExUnit.Case
  doctest Telegex.Marked

  import Telegex.Marked

  test "entities replace" do
    markdown = "[<Google&Search>](https://www.google.com)"
    html = ~s(<a href="https://www.google.com">&lt;Google&amp;Search&gt;</a>)

    assert as_html(markdown) == html
  end
end
