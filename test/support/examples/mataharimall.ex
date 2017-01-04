defmodule Spacerace.MMParser do
  use Spacerace.Parser

  def parse(resource, {:ok, resp}) do
    if resp.status_code in 200..299 do
      {:ok, success(resource, resp)}
    else
      {:error, fail(resource, resp)}
    end
  end

  def parse(resource, resp) do
    if resp.status_code in 200..299 do
      success(resource, resp)
    else
      fail(resource, resp)
    end
  end

  defp success(resource, %{body: body}) do
    results =
      body
      |> Poison.decode!()
      |> Map.get("results")

    if is_list(results),
      do: Enum.map(results, &resource.new/1),
      else: resource.new(results)
  end

  defp fail(_resource, %{body: body}) do
    Poison.decode!(body)
  end
end

defmodule Spacerace.MMClient do
  use Spacerace.Client

  def new(opts \\ []) do
    struct(__MODULE__, opts)
    |> put_base_url("http://apiseller.mataharimall.net/")
    |> add_header("Authorization", "Seller yourapitoken")
    |> add_header("Content-Type", "application/vnd.api+json")
    |> add_parser(Spacerace.MMParser)
  end
end

defmodule Spacerace.MMCategory do
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
