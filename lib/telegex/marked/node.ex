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

  defstruct [:type, :data, :parent, :first_child, :last_child, :prev, :next]

  @type t :: %__MODULE__{
          type: nodetypes(),
          data: %{String.t() => String.t()},
          parent: __MODULE__.t() | nil,
          first_child: __MODULE__.t() | nil,
          last_child: __MODULE__.t() | nil,
          prev: __MODULE__.t() | nil,
          next: __MODULE__.t() | nil
        }
end
