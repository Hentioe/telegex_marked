defmodule Telegex.MarkedTest do
  use ExUnit.Case
  doctest Telegex.Marked

  @markdown """
  *bold \*text*
  _italic \*text_
  __underline__
  ~strikethrough~
  *bold _italic bold ~italic bold strikethrough~ __underline italic bold___ bold*
  [inline URL](http://www.example.com/)
  [inline mention of a user](tg://user?id=123456789)
  `inline fixed-width code`
  ```
  pre-formatted fixed-width code block
  ```
  ```python
  pre-formatted fixed-width code block written in the Python programming language
  ```
  """

  test "as_html/1" do
    assert Telegex.Marked.as_html(@markdown) == "Not Implemented"
  end
end
