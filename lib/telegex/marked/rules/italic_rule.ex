defmodule Telegex.Marked.ItalicRule do
  @moduledoc false
  # Matching and parsing of italic nodes.

  use Telegex.Marked.Rule

  @markup "_"
  @ntype :italic

  @impl true
  def match(state) do
    %{line: %{src: src, len: len}, pos: pos} = state

    prev_char = String.at(src, pos - 1)
    next_char = String.at(src, pos + 1)

    if ignore_begin?(@markup, String.at(src, pos), prev_char, next_char) do
      {:nomatch, state}
    else
      chars = String.graphemes(String.slice(src, pos + 1, len))

      equals_markup_fun = fn {char, index} ->
        if char == @markup do
          Enum.at(chars, index + 1) != @markup && !escapes_char?(Enum.at(chars, index - 1))
        else
          false
        end
      end

      end_index =
        chars
        |> Enum.with_index()
        |> Enum.filter(equals_markup_fun)
        |> Enum.find(fn {_, index} ->
          # 跳过 underline 的标记符
          # 如果前一个也是 @markup 但前第二个不是，则不匹配（有且仅有两个 @markup 相连）
          [before_2, before_1] = Enum.slice(chars, (index - 2)..(index - 1))
          !(before_1 == @markup && before_2 != @markup)
        end)
        |> elem_or_nil(1)
        |> calculate_end_index(pos)

      if end_index do
        state = %{state | pos: end_index}

        state =
          State.push_node(state, %Node{
            type: @ntype,
            children: children_text(src, pos, end_index)
          })

        {:match, state}
      else
        {:nomatch, state}
      end
    end
  end
end
