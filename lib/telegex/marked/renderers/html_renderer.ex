defmodule Telegex.Marked.HTMLRenderer do
  @moduledoc """
  HTML rendering implementation.
  """

  use Telegex.Marked.Renderer

  @impl true
  def render(document, options \\ []) do
    root_nodes = options |> Keyword.get(:root_nodes, false)
    separator = if root_nodes, do: "\n", else: ""

    document |> Enum.map(&render_node/1) |> Enum.join(separator)
  end

  def render_node(%Node{type: :bold, children: children}) do
    children_html = render(children)
    "<b>" <> children_html <> "</b>"
  end

  def render_node(%Node{type: :italic, children: children}) do
    children_html = render(children)
    "<i>" <> children_html <> "</i>"
  end

  def render_node(%Node{type: :underline, children: children}) do
    children_html = render(children)
    "<u>" <> children_html <> "</u>"
  end

  def render_node(%Node{type: :strikethrough, children: children}) do
    children_html = render(children)
    "<s>" <> children_html <> "</s>"
  end

  def render_node(%Node{type: :link, children: children, data: data}) do
    children_html = render(children)

    if href = data |> Keyword.get(:href) do
      "<a href=\"#{href}\">" <> children_html <> "</a>"
    else
      "<a>" <> children_html <> "</a>"
    end
  end

  def render_node(%Node{type: :inline_code, children: children}) do
    children_html = render(children)
    "<code>" <> children_html <> "</code>"
  end

  def render_node(%Node{type: :code_block, data: data, children: children}) do
    children_html = render(children)

    if language = data |> Keyword.get(:language) do
      "<pre><code class=\"language-#{language}\">" <> children_html <> "</code></pre>"
    else
      "<pre>" <> children_html <> "</pre>"
    end
  end

  def render_node(%Node{type: :string, data: data}) do
    data
  end
end
