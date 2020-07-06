defmodule Telegex.Marked.UnderlineRule do
  @moduledoc """
  Matching and parsing of underline nodes.
  """

  use Telegex.Marked.Rule, mark: "__", type: :underline
end
