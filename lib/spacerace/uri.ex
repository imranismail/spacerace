defmodule Spacerace.URI do
  import Plug.Router.Utils, only: [build_path_match: 1]

  def prepare(endpoint, params) do
    endpoint
    |> build_path_match()
    |> elem(1)
    |> Enum.map(&replace_segment(&1, params))
    |> Enum.join("/")
  end

  defp replace_segment({key, _, _}, params), do: Map.get(params, key)
  defp replace_segment(segment, _), do: segment
end
