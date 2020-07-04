defmodule Telegex.Marked.Renderer do
  @moduledoc """
  Render node document.
  The specific rendering results are implemented by different rendering backends, such as `Telegex.Marked.Renderer.HTMLRenderer`.
  """
  defmacro __using__(_) do
    quote do
      @behaviour Telegex.Marked.Renderer
    end
  end

  @callback render(Telegex.Marked.Node.t()) :: String.t()
end
