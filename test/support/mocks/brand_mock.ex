defmodule Spacerace.BrandMock do
  use Spacerace,
    resource: "brand",
    resources: "brands",
    look_in: ["results"]

  embedded_schema do
    field :brand
  end

  post :all, "/master/brands",
    default: %{
      page: "1",
      limit: "30",
      orderby: "asc",
      sortby: "brand"
    }
end
