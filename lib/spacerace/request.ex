defmodule Spacerace.Request do
  def get(client, endpoint, params \\ %{}) do
    HTTPoison
    |> apply(:get, prepare_args_for(:get, client, endpoint, params))
    |> parse_response(client)
  end

  def get!(client, endpoint, params \\ %{}) do
    HTTPoison
    |> apply(:get!, prepare_args_for(:get, client, endpoint, params))
    |> parse_response(client)
  end

  def post(client, endpoint, params \\ %{}) do
    HTTPoison
    |> apply(:post, prepare_args_for(:post, client, endpoint, params))
    |> parse_response(client)
  end

  def post!(client, endpoint, params \\ %{}) do
    HTTPoison
    |> apply(:post!, prepare_args_for(:post, client, endpoint, params))
    |> parse_response(client)
  end

  defp parse_response(response, client) do
    Enum.reduce(client.parsers, response, &(&1.(&2, client)))
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
