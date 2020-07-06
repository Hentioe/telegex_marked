defmodule Telegex.Marked do
  @moduledoc """
  Safe Markdown parser/renderer for Telegram.
  """

  @type document :: [[Telegex.Marked.Node.t()]]

  @spec as_html(String.t()) :: String.t()
  @doc """
  Convert Markdown text to HTML text.
  """
  def as_html(_markdown) do
    "Not Implemented"
  end
end
