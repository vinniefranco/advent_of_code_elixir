defmodule AdventOfCode.Day7 do
  alias AdventOfCode.Day7.Machine

  def run_instructions(env, instructions) do
    Machine.run(env, instructions |> process_line_feed)
  end

  def process_line_feed(instructions) do
    instructions
    |> String.split("\n")
    |> Enum.map(&(&1 |> string_to_instruction_tuple))
  end

  def string_to_instruction_tuple(str) do
    str |> String.split(" ") |> List.to_tuple
  end

end
