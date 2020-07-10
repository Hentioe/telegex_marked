defmodule Telegex.Marked do
  @moduledoc """
  Safe Markdown parser/renderer for Telegram.
  """

  @type document :: [[Telegex.Marked.Node.t()]]
  @type state :: Telegex.Marked.InlineState.t() | Telegex.Marked.BlockState.t()
  @type match_status :: :match | :nomatch

  @spec as_html(String.t()) :: String.t()

  alias Telegex.Marked.{BlockParser, HTMLRenderer}

  @doc """
  Convert Markdown text to HTML text.
  """
  def as_html(markdown, _options \\ []) do
    markdown |> String.trim() |> BlockParser.parse() |> HTMLRenderer.render()
  end
end
