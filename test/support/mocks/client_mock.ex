defmodule Spacerace.ClientMock do
  @behaviour Spacerace.Client

  def new(opts \\ [base_url: "http://api.sb.mataharimall.com"]) do
    opts =
      opts
      |> Keyword.put(:headers, headers(opts))
      |> Keyword.put(:options, options(opts))

    struct(Spacerace.Client, opts)
  end

  def headers(_opts) do
    [{"Authorization", "Seller #{Application.get_env(:spacerace, :token)}"},
     {"Content-Type", "application/vnd.api+json"}]
  end

  def options(_opts) do
    []
  end
end
