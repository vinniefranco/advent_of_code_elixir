defmodule AdventOfCode.Day1 do
  @doc ~S"""
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
    str
    |> String.length
    |> with_negatives(str)
    |> compute_floor
  end

  defp with_negatives(total_length, str) do
    negatives_length =
      str
      |> String.replace("(", "")
      |> String.length

    {total_length, negatives_length}
  end

  defp compute_floor({total_length, total_negatives}) do
    (total_length - total_negatives) - total_negatives
  end
end
