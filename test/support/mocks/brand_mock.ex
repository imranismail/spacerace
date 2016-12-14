defmodule Spacerace.BrandMock do
  use Spacerace,
    resource: "brand",
    resources: "brands",
    look_in: ["results"]

  embedded_schema do
    field :brand
  end

  post :all, "/master/brands"
end
