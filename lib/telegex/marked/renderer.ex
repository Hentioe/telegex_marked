defmodule Telegex.Marked.Renderer do
  @moduledoc """
  Render node tree document.
  """
  defmacro __using__(_) do
    quote do
      @behaviour Telegex.Marked.Renderer

      alias Telegex.Marked.Node
    end
  end

  @doc """
  Render the node tree document as text content.
  The specific rendering result is implemented by the renderer that implements this function.
  """
  @callback render(document :: Telegex.Marked.document(), options :: keyword()) :: String.t()
end
