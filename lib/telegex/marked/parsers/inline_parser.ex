defmodule Telegex.Marked.InlineParser do
  @moduledoc """
  Parsing implementation of inline nodes.
  """

  use Telegex.Marked.Parser

  alias Telegex.Marked.{
    BoldRule,
    UnderlineRule,
    ItalicRule,
    StrikethroughRule,
    LinkRule,
    InlineCodeRule
  }

  @rule_modules [BoldRule, UnderlineRule, ItalicRule, StrikethroughRule, LinkRule, InlineCodeRule]

  @spec parse(String.t(), keyword()) :: Telegex.Marked.document()
  def parse(markdown, _options \\ []) do
    lines = markdown |> String.split("\n")
    lines_count = length(lines)
    lastline? = fn index -> index + 1 == lines_count end

    lines
    |> Enum.with_index()
    |> Enum.map(fn {line, index} -> parse_line(line, lastline?.(index), 0) end)
  end

  @spec parse_line(String.t(), boolean(), integer(), [Node.t()]) :: [Node.t()]
  defp parse_line(line, lastline?, pos, nodes \\ []) do
    init_state = State.new(line, pos)

    {ok?, state} = parse_node(init_state)

    nodes =
      if ok? do
        new_nodes = expand_children(state.nodes)

        if state.pos <= init_state.len - 1 do
          parse_line(line, lastline?, state.pos + 1, nodes ++ new_nodes)
        else
          if lastline?, do: nodes ++ new_nodes, else: nodes ++ new_nodes ++ [newline_node()]
        end
      else
        # 如果不匹配任何节点，逐字符继续匹配。
        # 如果最后一个节点也是字符串，则合并（避免逐字符匹配产生大量的连续单字符节点）。
        if state.pos <= init_state.len - 1 do
          len = length(nodes)
          this_char = String.at(line, state.pos)

          nodes =
            if len > 0 do
              {last_node, nodes} = nodes |> List.pop_at(len - 1)

              case last_node do
                # 合并字符到上一个字符串节点中
                %Node{type: :string, data: data} ->
                  nodes ++ [string_node(data <> this_char)]

                _ ->
                  nodes ++ [last_node, string_node(this_char)]
              end
            else
              nodes ++ [string_node(this_char)]
            end

          parse_line(line, lastline?, state.pos + 1, nodes)
        else
          if lastline?, do: nodes ++ state.nodes, else: nodes ++ state.nodes ++ [newline_node()]
        end
      end

    nodes
  end

  @spec expand_children(Node.t()) :: Node.t()
  defp expand_children(%Node{} = node) do
    if node.type in [:string, :newline] && is_binary(node.children) do
      node
    else
      %{node | children: parse_line(node.children, true, 0)}
    end
  end

  @spec expand_children([Node.t()]) :: [Node.t()]
  defp expand_children(nodes) when is_list(nodes) do
    nodes |> Enum.map(&expand_children/1)
  end

  @spec parse_node(State.t()) :: {boolean(), State.t()}
  defp parse_node(%State{} = state) do
    @rule_modules
    |> Enum.reduce_while({false, state}, fn rule_module, result ->
      {ok?, state} = rule_module.match?(state)

      if ok?, do: {:halt, {true, state}}, else: {:cont, result}
    end)
  end
end
