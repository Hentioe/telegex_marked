defmodule Telegex.Marked.BlockCodeRuleTest do
  use ExUnit.Case

  import Telegex.Marked.BlockCodeRule

  alias Telegex.Marked.{BlockState, Line}

  test "render/1" do
    code_block_no_language = """
    ```
    pre-formatted fixed-width code block
    ```
    """

    code_block_no_language_lines =
      code_block_no_language
      |> String.split("\n")
      |> Enum.map(fn line_src -> Line.new(line_src) end)

    code_block_no_language_match_state = %BlockState{
      lines: code_block_no_language_lines,
      len: length(code_block_no_language_lines),
      pos: 0,
      ending: 2,
      nodes: [
        %Telegex.Marked.Node{
          children: [
            %Telegex.Marked.Node{
              children: [],
              data: "pre-formatted fixed-width code block",
              type: :string
            }
          ],
          data: [language: nil],
          type: :code_block
        }
      ]
    }

    code_block_contains_language = """
    ```python
    pre-formatted fixed-width code block written in the Python programming language
    ```
    """

    code_block_contains_language_lines =
      code_block_contains_language
      |> String.split("\n")
      |> Enum.map(fn line_src -> Line.new(line_src) end)

    code_block_contains_language_match_state = %BlockState{
      lines: code_block_contains_language_lines,
      len: length(code_block_contains_language_lines),
      pos: 0,
      ending: 2,
      nodes: [
        %Telegex.Marked.Node{
          children: [
            %Telegex.Marked.Node{
              children: [],
              data:
                "pre-formatted fixed-width code block written in the Python programming language",
              type: :string
            }
          ],
          data: [language: "python"],
          type: :code_block
        }
      ]
    }

    assert match(BlockState.new(code_block_no_language_lines, 0)) ==
             {:match, code_block_no_language_match_state}

    assert match(BlockState.new(code_block_contains_language_lines, 0)) ==
             {:match, code_block_contains_language_match_state}
  end
end
