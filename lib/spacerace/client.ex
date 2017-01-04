defmodule Spacerace.Client do
  def put_base_url(client, url) do
    Map.put(client, :base_url, url)
  end

  def put_resource_module(client, module) do
    Map.put(client, :resource, module)
  end

  def add_header(client, key, value) do
    Map.update!(client, :headers, fn headers -> [{key, value}|headers] end)
  end

  def add_option(client, option) do
    Map.update!(client, :options, fn options -> [option|options] end)
  end

  def add_parser(client, parser) do
    Map.update!(client, :parsers, fn parsers -> parsers ++ [parser] end)
  end

  defmacro __using__(_) do
    quote bind_quoted: binding() do
      import Spacerace.Client

      defstruct [
        base_url: nil,
        headers: [],
        options: [],
        parsers: [],
        resource: nil
      ]

      @type t :: %__MODULE__{}
    end
  end
end
