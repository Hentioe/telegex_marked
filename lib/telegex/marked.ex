defmodule Telegex.Marked do
  @moduledoc """
  Safe Markdown parser/renderer for Telegram.
  """

  @type document :: [[Telegex.Marked.Node.t()]]
  @type state :: Telegex.Marked.InlineState.t() | Telegex.Marked.BlockState.t()
  @type inline_match_status :: :match | :nomatch
  @type match_status :: inline_match_status()

  @spec as_html(String.t()) :: String.t()
  @doc """
  Convert Markdown text to HTML text.
  """
  def as_html(_markdown) do
    "Not Implemented"
  end
end
