defmodule Telegex.Marked.BoldRule do
  @moduledoc """
  Matching and parsing of bold nodes.
  """

  use Telegex.Marked.Rule, mark: "*", type: :bold
end
