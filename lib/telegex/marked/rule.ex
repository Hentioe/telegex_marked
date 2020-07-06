defmodule Telegex.Marked.Rule do
  @moduledoc """
  Node matching and parsing rules.
  """

  alias Telegex.Marked.State

  defmacro __using__(_) do
    quote do
      @behaviour Telegex.Marked.Rule

      alias Telegex.Marked.{State, Node}

      import Telegex.Marked.{Node, Rule}
    end
  end

  @type ok? :: boolean()

  @callback match?(State.t()) :: {ok?(), State.t()}

  @spec calculate_end_index(nil, integer()) :: nil
  def calculate_end_index(nil = _index, _pos), do: nil
  @spec calculate_end_index(integer(), integer()) :: integer()
  def calculate_end_index(index, pos), do: index + 1 + pos

  @spec children_text(String.t(), integer(), integer()) :: String.t()
  def children_text(src, pos, end_index), do: String.slice(src, pos + 1, end_index - pos - 1)
end
