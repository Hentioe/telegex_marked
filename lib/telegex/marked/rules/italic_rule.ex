defmodule Telegex.Marked.ItalicRule do
  @moduledoc """
  Matching and parsing of italic nodes.
  """

  use Telegex.Marked.Rule, mark: "_", type: :italic
end
