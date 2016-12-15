defmodule Spacerace do
  defmacro __using__(opts) do
    quote bind_quoted: binding() do
      use Ecto.Schema

      import Ecto.Changeset
      import Spacerace

      @action_headers []
      @actions []

      @before_compile Spacerace
    end
  end

  defmacro __before_compile__(_) do
    quote bind_quoted: binding() do
      @embedded_fields Keyword.keys(@ecto_embeds)
      @action_headers Enum.uniq_by(@actions, fn {verb, _, _, _} -> verb end)
      @fields Keyword.drop(@ecto_fields, @embedded_fields) |> Keyword.keys()

      def __spacerace__(:actions), do: @actions

      def new(response) do
        %__MODULE__{}
        |> changeset(response)
        |> apply_changes()
      end

      def changeset(struct, params) do
        changeset = cast(struct, params, @fields)
        Enum.reduce(@embedded_fields, changeset, fn field, changeset ->
          cast_embed(changeset, field)
        end)
      end

      for {ver, fun, endpoint, opts} <- @action_headers do
        def unquote(fun)(client, args \\ [], params \\ %{})
      end

      for {verb, fun, endpoint, opts} <- @actions do
        default = Keyword.get(opts, :default, %{})

        if !is_map(default), do: raise ArgumentError, message: "Wrong option passed to default, expected a Map"

        def unquote(fun)(client, unquote(Spacerace.Helper.create_args(endpoint)) = args, params) do
          endpoint = Spacerace.Helper.prepare_uri(args, unquote(endpoint))
          params   = Map.merge(unquote(Macro.escape(default)), params)
          apply(Spacerace.Request, unquote(verb), [client, endpoint, params])
        end
      end

      defoverridable [new: 1, changeset: 2]
    end
  end

  defmacro get(fun, endpoint, opts \\ []) do
    quote bind_quoted: binding() do
      @actions [{:get, fun, endpoint, opts} | @actions]
    end
  end

  defmacro post(fun, endpoint, opts \\ []) do
    quote bind_quoted: binding() do
      @actions [{:post, fun, endpoint, opts} | @actions]
    end
  end
end
