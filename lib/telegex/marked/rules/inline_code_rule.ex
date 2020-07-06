defmodule Telegex.Marked.InlineCodeRule do
  @moduledoc """
  Matching and parsing of inline code nodes.
  """

  use Telegex.Marked.Rule, mark: "`", type: :inline_code
end
