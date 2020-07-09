defmodule Telegex.Marked.InlineState do
  @moduledoc false

  alias Telegex.Marked.{Node, Line}

  @enforce_keys [:line]
  defstruct line: nil, pos: 0, nodes: []

  @type t :: %__MODULE__{
          line: Line.t(),
          pos: integer(),
          nodes: [Node.t()]
        }

  @spec new(String.t(), integer()) :: t()
  def new(src, pos) when is_binary(src) and is_integer(pos) do
    %__MODULE__{
      line: Line.new(src),
      pos: pos
    }
  end

  @spec push_node(t(), Node.t()) :: t()
  def push_node(%__MODULE__{} = state, %Node{} = node) do
    %{state | nodes: state.nodes ++ [node]}
  end
end
