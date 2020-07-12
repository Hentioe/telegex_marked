defmodule Telegex.Marked.HTMLRenderer do
  @moduledoc """
  HTML rendering implementation.
  """

  use Telegex.Marked.Renderer

  @impl true
  def render(document, _options \\ []) do
    document |> Enum.map(&render_nodes/1) |> Enum.join("")
  end

  @doc """
  Render node list.

  Generally speaking, a node represents a line of content in Markdown text.
  """
  @spec render_nodes([Node.t()]) :: String.t()
  def render_nodes(nodes) do
    nodes |> Enum.map(&render_node/1) |> Enum.join("")
  end

  @doc """
  Render node.

  This function will render different HTML elements according to different node types, including child nodes.
  """
  @spec render_node(Node.t()) :: String.t()
  def render_node(%Node{type: :bold, children: children}) do
    children_html = render_nodes(children)
    "<b>" <> children_html <> "</b>"
  end

  def render_node(%Node{type: :italic, children: children}) do
    children_html = render_nodes(children)
    "<i>" <> children_html <> "</i>"
  end

  def render_node(%Node{type: :underline, children: children}) do
    children_html = render_nodes(children)
    "<u>" <> children_html <> "</u>"
  end

  def render_node(%Node{type: :strikethrough, children: children}) do
    children_html = render_nodes(children)
    "<s>" <> children_html <> "</s>"
  end

  def render_node(%Node{type: :link, data: data, children: children}) do
    children_html = render_nodes(children)

    if href = data |> Keyword.get(:href) do
      "<a href=\"#{href}\">" <> children_html <> "</a>"
    else
      "<a>" <> children_html <> "</a>"
    end
  end

  def render_node(%Node{type: :inline_code, children: children}) do
    children_html = render_nodes(children)
    "<code>" <> children_html <> "</code>"
  end

  def render_node(%Node{type: :code_block, data: data, children: children}) do
    children_html = render_nodes(children)

    if language = data |> Keyword.get(:language) do
      "<pre><code class=\"language-#{language}\">" <> children_html <> "</code></pre>"
    else
      "<pre>" <> children_html <> "</pre>"
    end
  end

  def render_node(%Node{type: :newline}) do
    "\n"
  end

  def render_node(%Node{type: :string, data: data}) do
    data
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
    |> String.replace(~r/\\([^\\])/, "\\g{1}")
    |> String.replace("ˇenscapeˇ", "\\")
  end
end
