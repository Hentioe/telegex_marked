defmodule Telegex.Marked.Node do
  @moduledoc """
  Element nodes in Markdown.
  """
  @type nodetypes ::
          :bold
          | :italic
          | :underline
          | :strikethrough
          | :link
          | :inline_code
          | :code_block
          | :newline
          | :string

  @enforce_keys [:type]
  defstruct type: nil, data: [], children: []

  @type t :: %__MODULE__{
          type: nodetypes(),
          data: [{atom(), String.t()}] | String.t(),
          children: [t()]
        }

  @spec string_node(String.t()) :: t()
  def string_node(text) do
    %__MODULE__{type: :string, data: text}
  end

  @spec string_children(String.t()) :: [t()]
  def string_children(text) do
    [string_node(text)]
  end

  @spec newline_node :: t()
  def newline_node() do
    %__MODULE__{type: :newline}
  end

  @spec newline_children :: [t()]
  def newline_children() do
    [newline_node()]
  end
end
