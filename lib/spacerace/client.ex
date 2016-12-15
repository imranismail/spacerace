defmodule Spacerace.Client do
  defstruct [
    base_url: nil,
    headers: [],
    options: []
  ]

  @type t :: %__MODULE__{}

  @callback new(any) :: __MODULE__.t
  @callback headers(any) :: keyword
  @callback options(any) :: keyword
end