defmodule Telegex.Marked.BlockParserTest do
  use ExUnit.Case

  import Telegex.Marked.BlockParser

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
      },
      %Telegex.Marked.Node{children: [], data: [], type: :newline}
    ],
    [
      %Telegex.Marked.Node{
        children: [
          %Telegex.Marked.Node{children: [], data: "bold ", type: :string},
          %Telegex.Marked.Node{
            children: [
              %Telegex.Marked.Node{children: [], data: "italic bold ", type: :string},
              %Telegex.Marked.Node{
                children: [
                  %Telegex.Marked.Node{
                    children: [],
                    data: "italic bold strikethrough",
                    type: :string
                  }
                ],
                data: [],
                type: :strikethrough
              },
              %Telegex.Marked.Node{children: [], data: " ", type: :string},
              %Telegex.Marked.Node{
                children: [
                  %Telegex.Marked.Node{children: [], data: "underline italic bold", type: :string}
                ],
                data: [],
                type: :underline
              }
            ],
            data: [],
            type: :italic
          },
          %Telegex.Marked.Node{children: [], data: " bold", type: :string}
        ],
        data: [],
        type: :bold
      },
      %Telegex.Marked.Node{children: [], data: [], type: :newline}
    ],
    [
      %Telegex.Marked.Node{
        children: [%Telegex.Marked.Node{children: [], data: "inline URL", type: :string}],
        data: [href: "http://www.example.com/"],
        type: :link
      },
      %Telegex.Marked.Node{children: [], data: [], type: :newline}
    ],
    [
      %Telegex.Marked.Node{
        children: [
          %Telegex.Marked.Node{children: [], data: "inline mention of a user", type: :string}
        ],
        data: [href: "tg://user?id=123456789"],
        type: :link
      },
      %Telegex.Marked.Node{children: [], data: [], type: :newline}
    ],
    [
      %Telegex.Marked.Node{
        children: [
          %Telegex.Marked.Node{children: [], data: "inline fixed-width code", type: :string}
        ],
        data: [],
        type: :inline_code
      },
      %Telegex.Marked.Node{children: [], data: [], type: :newline}
    ],
    [
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
      },
      %Telegex.Marked.Node{children: [], data: [], type: :newline}
    ],
    [
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
  ]

  test "render/1" do
    markdown = """
    normal1*bold1*normal2*blod2*normal3
    *bold __underline__ bold*
    *bold _italic bold ~italic bold strikethrough~ __underline italic bold___ bold*
    [inline URL](http://www.example.com/)
    [inline mention of a user](tg://user?id=123456789)
    `inline fixed-width code`
    ```
    pre-formatted fixed-width code block
    ```
    ```python
    pre-formatted fixed-width code block written in the Python programming language
    ```
    """

    markdown = markdown |> String.trim()

    assert parse(markdown) == @document_result
  end
end
