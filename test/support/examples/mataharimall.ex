defmodule Spacerace.MMClient do
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
    Map.put(client, :parsers, [&parse/2])
  end

  defp parse({:ok, resp}, client) do
    if resp.status_code in 200..299 do
      {:ok, success(resp, client)}
    else
      {:error, fail(resp, client)}
    end
  end

  defp parse(resp, client) do
    if resp.status_code in 200..299 do
      success(resp, client)
    else
      fail(resp, client)
    end
  end

  defp success(%{body: body}, client) do
    results =
      body
      |> Poison.decode!()
      |> Map.get("results")

    if is_list(results),
      do: Enum.map(results, &client.from.new/1),
      else: client.from.new(results)
  end

  defp fail(%{body: body}, _) do
    Poison.decode!(body)
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
