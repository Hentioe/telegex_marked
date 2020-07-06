defmodule Telegex.Marked.StrikethroughRule do
  @moduledoc """
  Matching and parsing of strikethrough nodes.
  """

  use Telegex.Marked.Rule, mark: "~", type: :strikethrough
end
