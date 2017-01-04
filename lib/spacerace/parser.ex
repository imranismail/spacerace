defmodule Spacerace.Parser do
  @callback parse(atom, any) :: any

  defmacro __using__(_) do
    quote do
      @behaviour Spacerace.Parser
    end
  end
end
