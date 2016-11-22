defmodule Sombra.Article do
  use Sombra,
    resource: "article",
    resources: "articles",
    look_in: ["data"]

  embedded_schema do
    field :title, :string
    field :body, :string
  end

  get :all, "/users/:user_id/articles"
end