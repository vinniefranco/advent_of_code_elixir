defmodule AdventOfCode.Day8 do

  def santas_encoded_list_size(input) do
    encoded = input |> total_lines_of_code(&encode_code/1)

    encoded - total_lines_of_code(input)
  end

  def santas_list_size(input) do
    input
    |> total_lines_of_code
    |> minus_total_chars_in_memory(input)
  end

  def encode_code(val) do
    Macro.to_string(quote do: unquote(val))
  end

  defp total_lines_of_code(input, code_fn \\ fn val -> val end) do
    input |> Enum.reduce(0, &(&2 + String.length(code_fn.(&1))))
  end

  defp minus_total_chars_in_memory(loc, input) do
    lines_in_mem = input |> Enum.reduce(0, &(&2 + eval_string_length(&1)))

    loc - lines_in_mem
  end

  defp eval_string_length(string) do
    string |> Code.eval_string |> eval_length
  end

  defp eval_length({nil, _}) do
    0
  end

  defp eval_length({str, _}) do
    str |> String.length
  end

end
