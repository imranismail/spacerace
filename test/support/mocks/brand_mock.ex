defmodule Spacerace.BrandMock do
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
