defmodule AdventOfCode.Day1 do
  @doc ~S"""
    Part 1

    Figures out which floor Santa needs to visit based on given `str`

    `str` contains two chars, both have meaning:
    "(" means add one
    ")" means minus one

    This method will figure out the `floor` when given a stream of `(` and `)`

    ## Examples

        iex> AdventOfCode.Day1.floor("(())")
        0

        iex> AdventOfCode.Day1.floor("()()")
        0

        iex> AdventOfCode.Day1.floor("(((")
        3

        iex> AdventOfCode.Day1.floor("(()(()(")
        3

        iex> AdventOfCode.Day1.floor("())")
        -1

        iex> AdventOfCode.Day1.floor("))(")
        -1

        iex> AdventOfCode.Day1.floor(")))")
        -3

        iex> AdventOfCode.Day1.floor(")())())")
        -3

  """
  def floor(str) do
    str |> String.length |> with_negatives(str) |> compute_floor
  end

  @doc ~S"""
    Part 2

    Now, given the same instructions, find the position of the first character
    that causes him to enter the basement (floor -1). The first character in
    the instructions has position 1, the second character has position 2, and so on.

    ## Examples

       iex> AdventOfCode.Day1.position(")")
       1

       iex> AdventOfCode.Day1.position("()())")
       5

       iex> AdventOfCode.Day1.position("(((")
       :error


  """
  def position(str) do
    on_position(str, 0, 0)
  end

  defp on_position(_str, position, -1) do
    position
  end

  defp on_position("", position, total) do
    :error
  end

  defp on_position("(" <> rest, position, total) do
    on_position(rest, position + 1, total + 1)
  end

  defp on_position(")" <> rest, position, total) do
    on_position(rest, position + 1, total - 1)
  end

  defp with_negatives(total_length, str) do
    negatives_length = str |> String.replace("(", "") |> String.length

    {total_length, negatives_length}
  end

  defp compute_floor({total_length, total_negatives}) do
    (total_length - total_negatives) - total_negatives
  end
end
