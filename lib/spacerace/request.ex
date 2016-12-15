defmodule Spacerace.Request do
  def get(client, endpoint, params \\ %{}) do
    apply(HTTPoison, :get, prepare_args_for(:get, client, endpoint, params))
  end

  def get!(client, endpoint, params \\ %{}) do
    apply(HTTPoison, :get!, prepare_args_for(:get, client, endpoint, params))
  end

  def post(client, endpoint, params \\ %{}) do
    apply(HTTPoison, :post!, prepare_args_for(:post, client, endpoint, params))
  end

  def post!(client, endpoint, params \\ %{}) do
    apply(HTTPoison, :post!, prepare_args_for(:post, client, endpoint, params))
  end

  defp prepare_args_for(:get, client, endpoint, params) do
    endpoint =
      if Enum.empty?(params) do
        URI.merge(client.base_url, endpoint)
      else
        client.base_url
        |> URI.merge(endpoint)
        |> URI.merge("?#{URI.encode_query(params)}")
      end

    [endpoint, client.headers, client.options]
  end

  defp prepare_args_for(:post, client, endpoint, params) do
    endpoint = URI.merge(client.base_url, endpoint)
    params   = Poison.encode!(params)
    [endpoint, params, client.headers, client.options]
  end
end
