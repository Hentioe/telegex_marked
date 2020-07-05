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
          | :string

  @enforce_keys [:type]
  defstruct type: nil, data: [], children: []

  @type t :: %__MODULE__{
          type: nodetypes(),
          data: [{atom(), String.t()}] | String.t(),
          children: [t()]
        }

  def string_node(text) do
    %__MODULE__{type: :string, data: text}
  end

  def string_children(text) do
    [string_node(text)]
  end
end
