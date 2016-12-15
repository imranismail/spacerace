defmodule Mataharimall.Client do
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

  def parsers(_opts) do
    [
      &parse_httpoison/1,
      &parse_json/1
    ]
  end

  defp parse_httpoison({:ok, %{body: body}}), do: Poison.decode(body)
  defp parse_httpoison(%{body: body}), do: Poison.decode!(body)
  defp parse_json({:ok, %{"results" => results}}), do: {:ok, results}
  defp parse_json(%{"results" => results}), do: results
end

defmodule Mataharimall.Brand do
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

  post :all, "/master/brands/:brand_id", default: %{
    page: "1",
    limit: "30",
    orderby: "asc",
    sortby: "brand"
  }
end

defmodule Mataharimall.Category do
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

defmodule Mataharimall.Color do
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
