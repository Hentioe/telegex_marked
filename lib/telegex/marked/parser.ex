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

  @typep parseopts :: keyword()

  alias Telegex.Marked.BlockParser

  @spec parse(String.t(), parseopts()) :: Telegex.Marked.document()
  @doc """
  Convert Markdown string to document (node tree).
  """
  def parse(markdown, options \\ []) do
    BlockParser.parse(markdown, options)
  end
end
