defmodule Spacerace.Client do
  defstruct [
    base_url: nil,
    headers: [],
    options: []
  ]

  @type t :: %__MODULE__{}

  @callback new(keyword)      :: __MODULE__.t
  @callback base_url(keyword) :: String.t
  @callback headers(keyword)  :: keyword
  @callback options(keyword)  :: keyword

  defmacro __using__(_) do
    quote bind_quoted: binding() do
      @behaviour Spacerace.Client

      def new(opts \\ []) do
        %Spacerace.Client{
          base_url: base_url(opts),
          headers: headers(opts),
          options: options(opts)
        }
      end
    end
  end
end
