defmodule AdventOfCode.Day8Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day8

  setup do
    lines = File.read!("test/support/spec-day8.txt") |> String.split("\n")
    {:ok, lines: lines}
  end

  @doc ~S"""
  For example, given the four strings above,
  the total number of characters of string code:
  (2 + 5 + 10 + 6 = 23) minus
  the total number of characters in memory for string values:
  (0 + 3 + 7 + 1 = 11) 

  23 - 11 = 12.
  """
  test "total code - total chars is 12", %{lines: lines} do
    assert Day8.santas_list_size(lines) == 12
  end
end
