defmodule Telegex.Marked.Parser do
  @moduledoc """
  Markdown parsing implementation.
  """

  defmacro __using__(_) do
    quote do
      alias Telegex.Marked.{State, Node}

      import Telegex.Marked.Node
    end
  end

  @type parseopts :: keyword()

  @spec parse(String.t(), parseopts()) :: Telegex.Marked.document()
  @doc """
  Convert Markdown string to document (node tree).
  """
  def parse(_markdown, _options \\ []) do
    []
  end
end
