defmodule Spacerace.Request do
  def get(client, endpoint, query_params \\ %{}) do
    endpoint =
      if Enum.empty?(query_params) do
        URI.merge(client.base_url, endpoint)
      else
        client.base_url
        |> URI.merge(endpoint)
        |> URI.merge("?#{URI.encode_query(query_params)}")
      end

    HTTPoison.get(endpoint, client.headers, client.options)
  end

  def post(client, endpoint, body \\ %{}) do
    endpoint = URI.merge(client.base_url, endpoint)
    body     = Poison.encode!(body)

    HTTPoison.post(endpoint, body, client.headers, client.options)
  end
end
