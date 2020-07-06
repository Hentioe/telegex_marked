defmodule Telegex.Marked.Rule do
  @moduledoc """
  Node matching and parsing rules.
  """

  alias Telegex.Marked.State

  defmacro __using__(options) do
    mark = options |> Keyword.get(:mark)
    type = options |> Keyword.get(:type)

    quote do
      @behaviour Telegex.Marked.Rule

      alias Telegex.Marked.{State, Node}

      import Telegex.Marked.{Node, Rule}

      if unquote(mark) do
        if String.length(unquote(mark)) > 1 do
          @mark unquote(mark)
          @mark_length @mark |> String.length()

          @impl true
          def match?(state) do
            %{src: src, pos: pos, len: len} = state

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
                      |> State.push_node(%Node{
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
        else
          @impl true
          def match?(state) do
            %{src: src, pos: pos, len: len} = state

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
                  |> State.push_node(%Node{
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
    end
  end

  @type ok? :: boolean()

  @callback match?(State.t()) :: {ok?(), State.t()}

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
