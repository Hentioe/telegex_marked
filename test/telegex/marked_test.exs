defmodule Telegex.MarkedTest do
  use ExUnit.Case
  doctest Telegex.Marked

  import Telegex.Marked

  test "entities replace" do
    markdown = "[<Google&Search>](https://www.google.com)"
    html = ~s(<a href="https://www.google.com">&lt;Google&amp;Search&gt;</a>)

    assert as_html(markdown) == html
  end

  # https://github.com/Hentioe/telegex_marked/issues/3
  test "issue#3" do
    markdown = """
    # ```
    # code
    # ```

    **continuous markup**
    """

    html = """
    # ```
    # code
    # ```

    *<b>continuous markup</b>*
    """

    assert as_html(markdown) == html
  end
end
