defmodule Spacerace.Mataharimall.Client do
  use Spacerace.Client

  def base_url(client, _opts) do
    Map.put(client, :base_url, "http://api.sb.mataharimall.com")

  end

  def headers(client, _opts) do
    Map.put(client, :headers, [
      {"Authorization", "Seller #{Application.get_env(:spacerace, :token)}"},
      {"Content-Type", "application/vnd.api+json"}
    ])
  end

  def options(client, _opts) do
    Map.put(client, :options, [])
  end

  def parsers(client, _opts) do
    Map.put(client, :parsers, [
      &parse_httpoison/1,
      &parse_json/1
    ])
  end

  defp parse_httpoison({:ok, resp}), do: parse_httpoison(resp)
  defp parse_httpoison(%{body: body, status_code: code}) when code in 200..299 do
    Poison.decode!(body)
  end
  defp parse_httpoison(%{body: body, status_code: code}) do
    raise Exception, message: """
        Request failed with error of: #{code}

            #{inspect(body)}
    """
  end

  defp parse_json({:ok, json}), do: {:ok, parse_json(json)}
  defp parse_json(%{"results" => results}), do: results
end

defmodule Spacerace.Mataharimall.Brand do
  use Spacerace

  embedded_schema do
    field :brand
  end

  post :all, "/master/brands", default: %{
    page: "1",
    limit: "30",
    orderby: "asc",
    sortby: "brand"
  }
end

defmodule Spacerace.Mataharimall.Category do
  use Spacerace

  embedded_schema do
    field :category
    field :code
    field :fg_active_hyper
    field :level
    field :parent_category_id
  end

  post :all, "/master/categories", default: %{
    page: "1",
    limit: "30",
    orderby: "asc",
    sortby: "category",
    parent_category_id: "NULL"
  }
end

defmodule Spacerace.Mataharimall.Color do
  use Spacerace

  embedded_schema do
    field :color
  end

  post :all, "/master/colors", default: %{
    page: "1",
    limit: "30",
    orderby: "asc",
    sortby: "color"
  }
end
