defmodule Telegex.Marked.Parser do
  @moduledoc """
  Markdown parsing implementation.
  """

  @type parseopts :: keyword()

  @spec parse(String.t(), parseopts()) :: Telegex.Marked.document()
  @doc """
  Convert Markdown string to document (node tree).
  """
  def parse(_markdown, _options \\ []) do
    []
  end
end
