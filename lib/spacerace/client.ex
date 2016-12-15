defmodule Spacerace.Client do
  defstruct [
    base_url: nil,
    headers: [],
    options: [],
    parsers: []
  ]

  @type t :: %__MODULE__{}

  @callback new(__MODULE__.t, keyword)      :: __MODULE__.t
  @callback base_url(__MODULE__.t, keyword) :: __MODULE__.t
  @callback headers(__MODULE__.t, keyword)  :: __MODULE__.t
  @callback options(__MODULE__.t, keyword)  :: __MODULE__.t
  @callback parsers(__MODULE__.t, keyword)  :: __MODULE__.t

  defmacro __using__(_) do
    quote bind_quoted: binding() do
      @behaviour Spacerace.Client

      def new(client \\ %Spacerace.Client{}, opts \\ []) do
        client
        |> base_url(opts)
        |> headers(opts)
        |> options(opts)
        |> parsers(opts)
      end
    end
  end
end
