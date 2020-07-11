defmodule Telegex.Marked.BlockParser do
  @moduledoc """
  Parsing implementation of block nodes.
  """

  use Telegex.Marked.Parser

  alias Telegex.Marked.BlockCodeRule
  alias Telegex.Marked.{Line, InlineParser}

  @rule_modules [BlockCodeRule]

  @spec parse(String.t(), keyword()) :: Telegex.Marked.document()
  @doc """
  Parse Markdown text, including inline elements.
  **Note**: This function is generally not called directly, please use `Telegex.Marked.as_html/2` instead.
  """
  def parse(markdown, _options \\ []) do
    markdown |> lines_info() |> parse_all(0)
  end

  @spec parse_all({[Line.t()], integer()}, integer(), [[Node.t()]]) :: Telegex.Marked.document()
  defp parse_all({lines, len} = lines_info, pos, nodes \\ [])
       when is_list(lines) and is_integer(len) and is_integer(pos) and is_list(nodes) do
    init_state = BlockState.new({lines, len}, pos)

    case parse_node(init_state) do
      {:match, state} ->
        if state.pos <= state.len - 1 && !BlockState.ending?(state) do
          parse_all(lines_info, state.ending + 1, nodes ++ [state.nodes ++ [newline_node()]])
        else
          nodes ++ [state.nodes]
        end

      {:nomatch, state} ->
        if state.pos <= state.len - 1 do
          inline_nodes = nomatch(state, false)
          parse_all(lines_info, state.pos + 1, nodes ++ [inline_nodes])
        else
          nodes ++ [nomatch(state, true)]
        end
    end
  end

  @spec nomatch(BlockState.t(), boolean()) :: [Node.t()]
  defp nomatch(state, lastline?) do
    state.lines
    |> Enum.at(state.pos)
    |> (fn %{src: src} -> src end).()
    |> InlineParser.parse_line(lastline?, 0)
  end

  @spec parse_node(BlockState.t()) :: {Telegex.Marked.Rule.match_status(), BlockState.t()}
  defp parse_node(%BlockState{} = state) do
    @rule_modules
    |> Enum.reduce_while({:nomatch, state}, fn rule_module, result ->
      {status, state} = rule_module.match(state)

      if status == :match, do: {:halt, {:match, state}}, else: {:cont, result}
    end)
  end

  @spec lines_info(String.t()) :: {[Line.t()], integer()}
  defp lines_info(text) do
    lines =
      text
      |> String.split("\n")
      |> Enum.map(fn line_src -> Line.new(line_src) end)

    {lines, length(lines)}
  end
end
