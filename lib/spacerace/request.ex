defmodule Spacerace.Request do
  def get(client, endpoint, params \\ %{}) do
    HTTPoison
    |> apply(:get, prepare_args_for(:get, client, endpoint, params))
    |> parse_response(client.parsers, client.resource)
  end

  def get!(client, endpoint, params \\ %{}) do
    HTTPoison
    |> apply(:get!, prepare_args_for(:get, client, endpoint, params))
    |> parse_response(client.parsers, client.resource)
  end

  def post(client, endpoint, params \\ %{}) do
    HTTPoison
    |> apply(:post, prepare_args_for(:post, client, endpoint, params))
    |> parse_response(client.parsers, client.resource)
  end

  def post!(client, endpoint, params \\ %{}) do
    HTTPoison
    |> apply(:post!, prepare_args_for(:post, client, endpoint, params))
    |> parse_response(client.parsers, client.resource)
  end

  defp parse_response(response, parsers, resource) do
    Enum.reduce(parsers, response, fn
      parser, response when is_function(parser) ->
        parser.(resource, response)
      parser, response when is_atom(parser) ->
        parser.parse(resource, response)
    end)
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
    params   = params |> Enum.into(%{}) |> Poison.encode!()
    [endpoint, params, client.headers, client.options]
  end
end
