defmodule Telegex.Marked.HTMLRendererTest do
  use ExUnit.Case

  import Telegex.Marked.{HTMLRenderer, Node}

  alias Telegex.Marked.Node

  @html_result """
  <b>bold</b>
  <i>italic</i>
  <u>underline</u>
  <s>strikethrough</s>
  <b>bold <i>italic bold <s>italic bold strikethrough</s> <u>underline italic bold</u></i> bold</b>
  <a href="http://www.example.com/">inline URL</a>
  <a href="tg://user?id=123456789">inline mention of a user</a>
  <code>inline fixed-width code</code>
  <pre>pre-formatted fixed-width code block</pre>
  <pre><code class="language-python">pre-formatted fixed-width code block written in the Python programming language</code></pre>
  """

  @html_result @html_result |> String.trim()

  test "render/1" do
    document = [
      %Node{type: :bold, children: string_children("bold")},
      %Node{type: :italic, children: string_children("italic")},
      %Node{type: :underline, children: string_children("underline")},
      %Node{type: :strikethrough, children: string_children("strikethrough")},
      %Node{
        type: :bold,
        children: [
          string_node("bold "),
          %Node{
            type: :italic,
            children: [
              string_node("italic bold "),
              %Node{
                type: :strikethrough,
                children: string_children("italic bold strikethrough")
              },
              string_node(" "),
              %Node{
                type: :underline,
                children: string_children("underline italic bold")
              }
            ]
          },
          string_node(" bold")
        ]
      },
      %Node{
        type: :link,
        data: [href: "http://www.example.com/"],
        children: string_children("inline URL")
      },
      %Node{
        type: :link,
        data: [href: "tg://user?id=123456789"],
        children: string_children("inline mention of a user")
      },
      %Node{
        type: :inline_code,
        children: string_children("inline fixed-width code")
      },
      %Node{
        type: :code_block,
        children: string_children("pre-formatted fixed-width code block")
      },
      %Node{
        type: :code_block,
        data: [language: "python"],
        children:
          string_children(
            "pre-formatted fixed-width code block written in the Python programming language"
          )
      }
    ]

    assert render(document, root_nodes: true) == @html_result
  end
end
