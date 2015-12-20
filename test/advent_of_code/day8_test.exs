defmodule AdventOfCode.Day8Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day8

  setup do
    lines = File.read!("test/support/spec-day8.txt") |> String.split("\n", trim: true)
    {:ok, lines: lines}
  end

  @doc ~S"""
  ""         2  loc 0 chars
  "abc"      5  loc 3 chars
  "aaa\"aaa" 10 loc 7 char
  "\x27"     6  loc 1 char
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

  @doc ~S"""
  "\"\""            6  loc 0 chars
  "\"abc\""         9  loc 3 chars
  "\"aaa\\\"aaa\"" 16  loc 7 char
  "\"\\x27\""      11  loc 1 char
  For example, given the four strings above,
  the total number of characters of string code:
  (4 + 9 + 16 + 11 = 42) minus
  the total number of characters in memory for string values:
  total_code_chars = 23

  42 - 23 = 19
  """
  test "total code - total chars is 19", %{lines: lines} do
    assert Day8.santas_encoded_list_size(lines) == 19
  end

  test "passes friends dataset returns at 2085" do
    lines = File.read!("test/support/day8.txt") |> String.split("\n", trim: true)

    assert Day8.santas_encoded_list_size(lines) == 2085
  end

  test "passes dataset returns at 2074" do
    lines = File.read!("test/support/day8-me.txt") |> String.split("\n", trim: true)

    assert Day8.santas_encoded_list_size(lines) == 2074
  end
end
