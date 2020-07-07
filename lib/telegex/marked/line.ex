defmodule Telegex.Marked.Line do
  @moduledoc false

  @enforce_keys [:src, :len]
  defstruct src: nil, len: nil

  @type t :: %__MODULE__{
          src: String.t(),
          len: integer()
        }

  @spec new(String.t()) :: t()
  def new(src) do
    %__MODULE__{src: src, len: String.length(src)}
  end
end
