defmodule AdventOfCode.Day10 do

  def look_and_say(input) do
    step(String.reverse(input), nil, [])
  end

  def step(<<head::binary - size(1), tail::binary>>, prev_char, [{count, char} | rest]) when head == prev_char do
    step(tail, head, [{count + 1, char}| rest])
  end

  def step(<<head::binary - size(1), tail::binary>>, _prev_char, explained) do
    step(tail, head, [{1, head} | explained])
  end

  def step("", _prev_char, explained) do
    explained |> Enum.reduce("", &(&2 <> tuple_to_str(&1)))
  end

  defp tuple_to_str(tuple) do
    tuple |> Tuple.to_list |> Enum.join
  end

end
