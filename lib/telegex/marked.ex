defmodule Telegex.Marked do
  @moduledoc """
  Safe Markdown parser/renderer for Telegram.
  """

  @typedoc "The node tree that makes up the document."
  @type document :: [[Telegex.Marked.Node.t()]]

  alias Telegex.Marked.{BlockParser, HTMLRenderer}

  @spec as_html(String.t()) :: String.t()
  @doc """
  Convert Markdown text to HTML text.  
  **Note**: The current `options` parameter is reserved and has no practical meaning.
  """
  def as_html(markdown, _options \\ []) do
    markdown |> String.trim() |> BlockParser.parse() |> HTMLRenderer.render()
  end
end
