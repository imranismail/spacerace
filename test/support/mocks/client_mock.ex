defmodule Spacerace.ClientMock do
  use Spacerace.Client

  def base_url(_opts) do
    "http://api.sb.mataharimall.com"
  end

  def headers(_opts) do
    [{"Authorization", "Seller #{Application.get_env(:spacerace, :token)}"},
     {"Content-Type", "application/vnd.api+json"}]
  end

  def options(_opts) do
    []
  end
end
