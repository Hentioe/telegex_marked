defmodule Telegex.Marked do
  @moduledoc """
  Safe Markdown parser/renderer for Telegram.
  """

  @typedoc "The node tree that makes up the document."
  @type document :: [[Telegex.Marked.Node.t()]]

  alias Telegex.Marked.{BlockParser, HTMLRenderer}

  @doc """
  Convert Markdown text to HTML text.

  ## Examples
      iex> markdown = \"\"\"
      ...> *bold*
      ...> _italic_
      ...> __underline__
      ...> ~strikethrough~
      ...> *bold _italic bold ~italic bold strikethrough~ __underline italic bold___ bold*
      ...> [inline URL](http://www.example.com/)
      ...> [inline mention of a user](tg://user?id=123456789)
      ...> `inline fixed-width code`
      ...> ```
      ...> pre-formatted fixed-width code block
      ...> ```
      ...> ```python
      ...> pre-formatted fixed-width code block written in the Python programming language
      ...> ```
      ...> \"\"\"
      ...>
      ...> html = \"\"\"
      ...> <b>bold</b>
      ...> <i>italic</i>
      ...> <u>underline</u>
      ...> <s>strikethrough</s>
      ...> <b>bold <i>italic bold <s>italic bold strikethrough</s> <u>underline italic bold</u></i> bold</b>
      ...> <a href="http://www.example.com/">inline URL</a>
      ...> <a href="tg://user?id=123456789">inline mention of a user</a>
      ...> <code>inline fixed-width code</code>
      ...> <pre>pre-formatted fixed-width code block</pre>
      ...> <pre><code class="language-python">pre-formatted fixed-width code block written in the Python programming language</code></pre>
      ...> \"\"\"
      ...>
      ...> Telegex.Marked.as_html(markdown) == html
      true

  Note: The current `options` parameter is reserved and has no practical meaning.
  """
  @spec as_html(String.t()) :: String.t()
  def as_html(markdown, _options \\ []) do
    markdown |> BlockParser.parse() |> HTMLRenderer.render()
  end

  @doc ~S"""
  Escape the Markdown markups contained in the text.

  ## Examples
      iex> Telegex.Marked.escape_text("*_~[]()`")
      ~S"\*\_\~\[\]\(\)\`"

  Note: The current options parameter is reserved and has no practical meaning.
  """
  @spec escape_text(String.t(), keyword()) :: String.t()
  def escape_text(text, _options \\ []) do
    String.replace(text, ~r/(\*|_|~|\[|\]|\(|\)|`)/, "\\\\\\g{1}")
  end
end
