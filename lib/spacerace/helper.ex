defmodule Spacerace.Helper do
  def create_args(endpoint) do
    ~r/:(\w+)/
    |> Regex.scan(endpoint, capture: :all_but_first)
    |> Enum.concat()
    |> Enum.map(&String.to_atom/1)
    |> Enum.map(fn key ->
      quote do
        {unquote(key), unquote(Macro.var(key, __MODULE__))}
      end
    end)
  end

  def prepare_uri(params, endpoint) do
    Enum.reduce(params, endpoint, fn {param_key, param_val}, endpoint ->
      String.replace(endpoint, ":#{param_key}", to_string(param_val))
    end)
  end
end
