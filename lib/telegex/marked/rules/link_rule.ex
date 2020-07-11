defmodule Telegex.Marked.LinkRule do
  @moduledoc false
  # Matching and parsing of link nodes.

  use Telegex.Marked.Rule

  @ntype :link

  @open_bracket "["
  @close_bracket "]"
  @open_parenthesis "("
  @close_parenthesis ")"

  @impl true
  def match(state) do
    %{line: %{src: src, len: len}, pos: pos} = state

    if String.at(src, pos) != @open_bracket do
      {:nomatch, state}
    else
      chars = String.graphemes(String.slice(src, pos + 1, len))

      # 找到中括号的关闭位置，用于取出链接文字
      # 找到小括号的关闭位置，用于取出链接地址
      # 任其一没有找到，则不匹配
      with {:ok, close_bracket_pos} <- find_close_bracket_pos(chars),
           {:ok, close_parenthesis_pos} <-
             find_close_parenthesis_pos(close_bracket_pos, chars) do
        text = String.slice(src, pos + 1, close_bracket_pos)
        href = String.slice(src, close_bracket_pos + 3, close_parenthesis_pos - 1)
        state = %{state | pos: close_bracket_pos + close_parenthesis_pos + 2}

        state =
          State.push_node(state, %Node{
            type: @ntype,
            data: [href: href],
            children: text
          })

        {:match, state}
      else
        _ ->
          {:nomatch, state}
      end
    end
  end

  @spec find_close_bracket_pos([String.t()]) :: {:ok, integer()} | nil
  defp find_close_bracket_pos(chars) do
    result =
      chars
      |> Enum.with_index()
      |> Enum.filter(fn {char, index} ->
        # 后一个字符是 @open_parenthesis
        char == @close_bracket && Enum.at(chars, index + 1) == @open_parenthesis
      end)
      # 始终匹配最后一个 @close_bracket + @open_parenthesis
      |> List.last()

    case result do
      {_, pos} -> {:ok, pos}
      nil -> nil
    end
  end

  @spec find_close_parenthesis_pos(integer(), [String.t()]) :: {:ok, integer()} | nil
  defp find_close_parenthesis_pos(close_bracket_pos, chars) do
    parentheses_chars = chars |> Enum.slice((close_bracket_pos + 1)..-1)

    pos =
      parentheses_chars
      |> Enum.find_index(fn char ->
        char == @close_parenthesis
      end)

    if pos, do: {:ok, pos}, else: nil
  end
end
