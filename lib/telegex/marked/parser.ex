defmodule Telegex.Marked.Parser do
  @moduledoc """
  Markdown parsing implementation.
  """

  defmacro __using__(_) do
    quote do
      alias Telegex.Marked.Node
      alias Telegex.Marked.{InlineState, BlockState}

      import Telegex.Marked.Node
    end
  end

  alias Telegex.Marked.BlockParser

  @doc """
  Convert Markdown string to document (node tree).
  """
  @spec parse(String.t(), keyword()) :: Telegex.Marked.document()
  def parse(markdown, options \\ []) do
    BlockParser.parse(markdown, options)
  end
end
