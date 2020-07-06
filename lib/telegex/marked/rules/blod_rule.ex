defmodule Telegex.Marked.BoldRule do
  @moduledoc """
  Matching and parsing of bold nodes.
  """

  use Telegex.Marked.Rule

  @impl true
  def match?(state) do
    %{src: src, pos: pos, len: len} = state

    if String.at(src, pos) != "*" do
      {false, state}
    else
      chars = String.graphemes(String.slice(src, pos + 1, len))

      end_index =
        chars
        |> Enum.find_index(&(&1 == "*"))
        |> calculate_end_index(pos)

      if end_index do
        state = %{state | pos: end_index}

        state =
          state
          |> State.push_node(%Node{
            type: :bold,
            children: children_text(src, pos, end_index)
          })

        {true, state}
      else
        {false, state}
      end
    end
  end
end
