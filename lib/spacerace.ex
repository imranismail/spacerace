defmodule Spacerace do  
  defmacro __using__(opts) do
    quote bind_quoted: binding() do
      use Ecto.Schema

      import Spacerace, only: [get: 2]

      @resources opts[:resources]
      @resource opts[:resource]
      @look_in opts[:look_in]
      @before_compile Spacerace

      def __schema__(:resources), do: @resources
      def __schema__(:resource), do: @resource
      def __schema__(:look_in), do: @look_in
    end
  end
  
  defmacro __before_compile__(_) do
    quote do
      @embedded_fields Keyword.keys(@ecto_embeds)

      @fields @ecto_fields
        |> Keyword.drop(@embedded_fields)
        |> Keyword.keys()

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
      
      defoverridable [new: 1, changeset: 2]
    end
  end

  defmacro get(fun, endpoint) do
    quote do
      def unquote(fun)(unquote(Spacerace.create_args(endpoint)) = args) do
        Spacerace.prepare_uri(args, unquote(endpoint))
      end
    end
  end

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
