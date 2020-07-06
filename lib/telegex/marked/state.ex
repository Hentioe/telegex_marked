defmodule Telegex.Marked.State do
  @moduledoc false

  alias Telegex.Marked.Node

  @enforce_keys [:src, :len]
  defstruct src: nil, pos: 0, len: nil, nodes: []

  @type t :: %__MODULE__{
          src: String.t(),
          pos: integer(),
          len: integer(),
          nodes: [Node.t()]
        }

  @spec new(String.t(), integer()) :: t()
  def new(src, pos) when is_binary(src) and is_integer(pos) do
    %__MODULE__{
      src: src,
      pos: pos,
      len: String.length(src),
      nodes: []
    }
  end

  @spec push_node(t(), Node.t()) :: t()
  def push_node(%__MODULE__{} = state, %Node{} = node) do
    %{state | nodes: state.nodes ++ [node]}
  end
end
