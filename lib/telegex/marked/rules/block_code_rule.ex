defmodule Telegex.Marked.BlockCodeRule do
  @moduledoc false
  # Matching and parsing of block code nodes.

  use Telegex.Marked.Rule

  @mark "```"
  @mlen String.length(@mark)
  @ntype :code_block

  @impl true
  def match(state) do
    %{lines: lines, len: len, pos: pos} = state

    first_line = Enum.at(lines, pos)

    if len == 0 || !String.starts_with?(first_line.src, @mark) do
      {:nomatch, state}
    else
      ending_pos =
        lines
        |> Enum.slice((pos + 1)..-1)
        |> Enum.find_index(fn line ->
          String.starts_with?(line.src, @mark)
        end)
        |> calculate_ending_pos(pos)

      if ending_pos do
        language =
          if first_line.len > @mlen do
            String.slice(first_line.src, 3..-1) |> String.trim()
          else
            nil
          end

        code_block_text =
          lines
          |> Enum.slice((pos + 1)..(ending_pos - 1))
          |> Enum.map(fn line -> "#{line.src}" end)
          |> Enum.join("\n")

        state = %{state | ending: ending_pos}

        state =
          State.push_node(state, %Node{
            type: @ntype,
            data: [language: language],
            children: [string_node(code_block_text)]
          })

        {:match, state}
      else
        {:nomatch, state}
      end
    end
  end

  defp calculate_ending_pos(nil, _pos), do: nil

  defp calculate_ending_pos(ending_pos, pos) when is_integer(pos) do
    ending_pos + pos + 1
  end
end
