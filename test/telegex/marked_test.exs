defmodule Telegex.MarkedTest do
  use ExUnit.Case
  doctest Telegex.Marked

  import Telegex.Marked

  test "escape_text/2" do
    link_text = "*_~[]()`\\"

    markdown = """
    [#{escape_text(link_text)}](link://path)
    """

    html = """
    <a href="link://path">*_~[]()`\\</a>
    """

    assert as_html(markdown) == html
  end

  test "entities replace" do
    markdown = "[<Google&Search>](https://www.google.com)"
    html = ~s(<a href="https://www.google.com">&lt;Google&amp;Search&gt;</a>)

    assert as_html(markdown) == html
  end

  @tag :escape_markups
  test "escape markups" do
    markdown = ~S"""
    \`code\`
    \```
    code block
    ```
    \*normal*
    \_*bold*_
    \[link](link://path)
    \\
    """

    html = ~S"""
    `code`
    ```
    code block
    ```
    *normal*
    _<b>bold</b>_
    [link](link://path)
    \
    """

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

  # https://github.com/Hentioe/telegex_marked/issues/9
  @tag :issue9
  test "issue/9" do
    markdown = ~S"""
    _来自『*\*\_\~\[\]\(\)\`\\*』的验证，请确认问题并选择您认为正确的答案。_
    """

    html = ~S"""
    <i>来自『<b>*_~[]()`\</b>』的验证，请确认问题并选择您认为正确的答案。</i>
    """

    assert as_html(markdown) == html
  end
end
