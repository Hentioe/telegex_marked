defmodule Telegex.Marked.InlineCodeRule do
  @moduledoc false
  # Matching and parsing of inline code nodes.

  use Telegex.Marked.Rule, mark: "`", type: :inline_code
end
