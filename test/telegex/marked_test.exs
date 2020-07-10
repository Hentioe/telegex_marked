defmodule Telegex.MarkedTest do
  use ExUnit.Case
  doctest Telegex.Marked

  @markdown """
  *bold*
  _italic_
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

  @html """
  <b>bold</b>
  <i>italic</i>
  <u>underline</u>
  <s>strikethrough</s>
  <b>bold <i>italic bold <s>italic bold strikethrough</s> <u>underline italic bold</u></i> bold</b>
  <a href="http://www.example.com/">inline URL</a>
  <a href="tg://user?id=123456789">inline mention of a user</a>
  <code>inline fixed-width code</code>
  <pre>pre-formatted fixed-width code block</pre>
  <pre><code class="language-python">pre-formatted fixed-width code block written in the Python programming language</code></pre>
  """

  test "as_html/1" do
    assert Telegex.Marked.as_html(@markdown) == @html |> String.trim()
  end
end
