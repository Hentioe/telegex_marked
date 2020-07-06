defmodule Telegex.Marked.InlineParserTest do
  use ExUnit.Case

  import Telegex.Marked.InlineParser

  @document_result [
    [
      %Telegex.Marked.Node{children: [], data: "normal1", type: :string},
      %Telegex.Marked.Node{
        children: [%Telegex.Marked.Node{children: [], data: "bold1", type: :string}],
        data: [],
        type: :bold
      },
      %Telegex.Marked.Node{children: [], data: "normal2", type: :string},
      %Telegex.Marked.Node{
        children: [%Telegex.Marked.Node{children: [], data: "blod2", type: :string}],
        data: [],
        type: :bold
      },
      %Telegex.Marked.Node{children: [], data: "normal3", type: :string},
      %Telegex.Marked.Node{children: [], data: [], type: :newline}
    ],
    [
      %Telegex.Marked.Node{
        children: [
          %Telegex.Marked.Node{children: [], data: "bold ", type: :string},
          %Telegex.Marked.Node{
            children: [%Telegex.Marked.Node{children: [], data: "underline", type: :string}],
            data: [],
            type: :underline
          },
          %Telegex.Marked.Node{children: [], data: " bold", type: :string}
        ],
        data: [],
        type: :bold
      }
    ]
  ]

  test "render/1" do
    markdown = """
    normal1*bold1*normal2*blod2*normal3
    *bold __underline__ bold*
    """

    markdown = markdown |> String.trim()
    # document = parse(markdown)

    # Telegex.Marked.HTMLRenderer.render(document) |> IO.puts()

    assert parse(markdown) == @document_result
  end
end
