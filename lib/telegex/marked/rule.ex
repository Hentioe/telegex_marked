defmodule Telegex.Marked.Rule do
  @moduledoc false
  # Node matching and parsing rules.

  @type match_status :: :match | :nomatch
  @type state :: Telegex.Marked.InlineState.t() | Telegex.Marked.BlockState.t()

  defmacro __using__(options) do
    makrup = options |> Keyword.get(:mark)
    node_type = options |> Keyword.get(:type)

    if makrup do
      if String.length(makrup) > 1 do
        implement_multi_markup(makrup, node_type)
      else
        implement_single_markup(makrup, node_type)
      end
    else
      using()
    end
  end

  defp using() do
    quote do
      @behaviour Telegex.Marked.Rule

      alias Telegex.Marked.Node
      alias Telegex.Marked.{State, InlineState, BlockState}

      import Telegex.Marked.{Node, Rule}
    end
  end

  defp implement_single_markup(markup, node_type) do
    quote do
      unquote(using())

      @impl true
      def match(state) do
        %{line: %{src: src, len: len}, pos: pos} = state

        prev_char = String.at(src, pos - 1)
        next_char = String.at(src, pos + 1)

        if ignore_begin?(unquote(markup), String.at(src, pos), prev_char, next_char) do
          {:nomatch, state}
        else
          chars = String.graphemes(String.slice(src, pos + 1, len))

          end_index =
            chars
            |> Enum.with_index()
            |> Enum.find_index(fn {char, index} ->
              char == unquote(markup)
            end)
            |> calculate_end_index(pos)

          if end_index do
            state = %{state | pos: end_index}

            state =
              State.push_node(state, %Node{
                type: unquote(node_type),
                children: children_text(src, pos, end_index)
              })

            {:match, state}
          else
            {:nomatch, state}
          end
        end
      end
    end
  end

  defp implement_multi_markup(mark, type) do
    quote do
      unquote(using())

      @mark unquote(mark)
      @mark_length @mark |> String.length()

      @impl true
      def match(state) do
        %{line: %{src: src, len: len}, pos: pos} = state

        begin_at_src = String.slice(src, pos, len)

        if String.starts_with?(begin_at_src, @mark) do
          remainder_src =
            String.slice(begin_at_src, @mark_length - 1, String.length(begin_at_src))

          case remainder_src |> :binary.match(@mark) do
            {begin_index, _} ->
              end_index = begin_index |> calculate_end_index(pos, @mark_length)

              if end_index != nil do
                state = %{state | pos: end_index}

                state =
                  State.push_node(state, %Node{
                    type: unquote(type),
                    children: children_text(src, pos, end_index, @mark_length)
                  })

                {:match, state}
              else
                {:nomatch, state}
              end

            :nomatch ->
              {:nomatch, state}
          end
        else
          {:nomatch, state}
        end
      end
    end
  end

  @callback match(state :: state()) :: {match_status(), state()}

  @spec ignore_begin?(String.t(), String.t(), String.t(), String.t()) :: boolean()
  def ignore_begin?(markup, pos_char, prev_char, next_char),
    do:
      pos_char != markup ||
        escapes_char?(prev_char) ||
        next_char == markup

  @doc ~S"""
  iex> <<92>> == "\\"
  true
  """
  @spec escapes_char?(String.t()) :: boolean()
  def escapes_char?(<<92>>), do: true
  def escapes_char?(_), do: false

  def remove_index({elem, _index}), do: elem
  def remove_index(nil), do: nil

  def elem_or_nil(nil, _index), do: nil
  def elem_or_nil(tuple, index), do: elem(tuple, index)

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
