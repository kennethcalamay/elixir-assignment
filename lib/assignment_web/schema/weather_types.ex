defmodule AssignmentWeb.Schema.WeatherTypes do
  use Absinthe.Schema.Notation

  @desc """
  The coordinate input.
  """
  input_object :coordinate_input do
    field :latitude, non_null(:number_or_string)
    field :longitude, non_null(:number_or_string)
  end

  @desc """
  A polymorphic type. Accepts a number, or a numeric string.
  """
  scalar :number_or_string do
    parse fn
      %{value: input} -> parse_input(input)
      _ -> :error
    end

    serialize fn value ->
      "#{value}"
    end
  end

  defp parse_input(input) when is_integer(input), do: {:ok, input * 1.0}
  defp parse_input(input) when is_float(input), do: {:ok, input}
  defp parse_input(input) when is_binary(input) do
    with {float, ""} <- Float.parse(input), do: {:ok, float}
  end
end
