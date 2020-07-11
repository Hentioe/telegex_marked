defprotocol Telegex.Marked.State do
  @moduledoc false

  @spec push_node(t(), Telegex.Marked.Node.t()) :: t()
  def push_node(state, node)
end

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

  defimpl Telegex.Marked.State do
    def push_node(state, %Node{} = node) do
      %{state | nodes: state.nodes ++ [node]}
    end
  end
end

defmodule Telegex.Marked.BlockState do
  @moduledoc false

  alias Telegex.Marked.{Node, Line}

  @enforce_keys [:lines]
  defstruct lines: [], len: nil, pos: 0, ending: nil, nodes: []

  @type t :: %__MODULE__{
          lines: [Line.t()],
          len: integer(),
          pos: integer(),
          nodes: [Node.t()]
        }

  @spec new([Line.t()], integer()) :: t()
  def new(lines, pos) when is_list(lines) and is_integer(pos) do
    new({lines, length(lines)}, pos)
  end

  @spec new({[Line.t()], integer()}, integer()) :: t()
  def new({lines, len}, pos) when is_list(lines) and is_integer(len) and is_integer(pos) do
    %__MODULE__{
      lines: lines,
      len: len,
      pos: pos
    }
  end

  @spec lastline?(t()) :: boolean()
  def lastline?(%{pos: pos, len: len}), do: pos + 1 == len

  @spec ending?(t()) :: boolean()
  def ending?(%{ending: ending, len: len}), do: ending + 1 == len

  defimpl Telegex.Marked.State do
    def push_node(state, %Node{} = node) do
      %{state | nodes: state.nodes ++ [node]}
    end
  end
end
