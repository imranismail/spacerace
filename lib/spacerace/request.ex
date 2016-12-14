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

    endpoint
    |> HTTPoison.get(client.headers, client.options)
    |> handle_response()
  end

  def post(client, endpoint, body \\ %{}) do
    endpoint = URI.merge(client.base_url, endpoint)
    body     = Poison.encode!(body)

    endpoint
    |> HTTPoison.post(body, client.headers, client.options)
    |> handle_response()
  end

  defp handle_response({:ok, response}) do
    response
    |> Map.get(:body)
    |> Poison.decode!()
  end
end
