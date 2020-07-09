defmodule Telegex.Marked.Rule do
  @moduledoc """
  Node matching and parsing rules.
  """

  defmacro create_push_node_fun do
    quote do
      @spec push_node(t(), Node.t()) :: t()
      def push_node(%__MODULE__{} = state, %Node{} = node) do
        %{state | nodes: state.nodes ++ [node]}
      end
    end
  end

  defmacro __using__(options) do
    mark = options |> Keyword.get(:mark)
    type = options |> Keyword.get(:type)

    if mark do
      if String.length(mark) > 1 do
        implement_multi_mark(mark, type)
      else
        implement_single_mark(mark, type)
      end
    else
      using(:inline)
    end
  end

  defp using(:inline) do
    quote do
      @behaviour Telegex.Marked.Rule

      alias Telegex.Marked.Node
      alias Telegex.Marked.InlineState

      import Telegex.Marked.{Node, Rule}
    end
  end

  defp implement_multi_mark(mark, type) do
    quote do
      unquote(using(:inline))

      @mark unquote(mark)
      @mark_length @mark |> String.length()

      @impl true
      def match?(state) do
        %{line: %{src: src, len: len}, pos: pos} = state

        begin_at_src = src |> String.slice(pos, len)

        if String.starts_with?(begin_at_src, @mark) do
          remainder_src =
            begin_at_src |> String.slice(@mark_length - 1, String.length(begin_at_src))

          case remainder_src |> :binary.match(@mark) do
            {begin_index, _} ->
              end_index = begin_index |> calculate_end_index(pos, @mark_length)

              if end_index != nil do
                state = %{state | pos: end_index}

                state =
                  state
                  |> InlineState.push_node(%Node{
                    type: unquote(type),
                    children: children_text(src, pos, end_index, @mark_length)
                  })

                {true, state}
              else
                {false, state}
              end

            :nomatch ->
              {false, state}
          end
        else
          {false, state}
        end
      end
    end
  end

  defp implement_single_mark(mark, type) do
    quote do
      unquote(using(:inline))

      @impl true
      def match?(state) do
        %{line: %{src: src, len: len}, pos: pos} = state

        if String.at(src, pos) != unquote(mark) do
          {false, state}
        else
          chars = String.graphemes(String.slice(src, pos + 1, len))

          end_index =
            chars
            |> Enum.find_index(&(&1 == unquote(mark)))
            |> calculate_end_index(pos)

          if end_index do
            state = %{state | pos: end_index}

            state =
              state
              |> InlineState.push_node(%Node{
                type: unquote(type),
                children: children_text(src, pos, end_index)
              })

            {true, state}
          else
            {false, state}
          end
        end
      end
    end
  end

  @type ok? :: boolean()

  @callback match?(Telegex.Marked.state()) :: {ok?(), Telegex.Marked.state()}

  @spec calculate_end_index(integer() | nil, integer()) :: integer() | nil
  def calculate_end_index(index, pos), do: calculate_end_index(index, pos, 1)
  @spec calculate_end_index(nil, integer(), integer()) :: nil
  def calculate_end_index(nil = _index, _pos, _mark_length), do: nil
  @spec calculate_end_index(integer(), integer(), integer()) :: integer()
  def calculate_end_index(index, pos, mark_length), do: index + mark_length + pos

  @spec children_text(String.t(), integer(), integer()) :: String.t()
  def children_text(src, pos, end_index), do: String.slice(src, pos + 1, end_index - pos - 1)
  @spec children_text(String.t(), integer(), integer(), integer()) :: String.t()
  def children_text(src, pos, end_index, mark_length),
    do: String.slice(src, pos + mark_length, end_index - pos - mark_length - 1)
end
