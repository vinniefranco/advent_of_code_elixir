defmodule AdventOfCode.Day6.BitGridTest do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day6.BitGrid

  setup do
    BitGrid.start_link(5)

    :ok
  end

  test "turn_on/2 when given a start point and end point it turns on the correct bits" do
    BitGrid.turn_on({2, 2}, {4, 4})

    assert BitGrid.total_lit == 9
  end

  test "turn_off/2 when given start/end points it should turn off the correct bits" do
    BitGrid.turn_on({2, 2}, {4, 4})
    assert BitGrid.total_lit == 9

    BitGrid.turn_off({3, 3}, {4, 4})
    assert BitGrid.total_lit == 5
  end

  test "toggle/2 when given start/end points it toggle the correct bits" do
    BitGrid.turn_on({2, 2}, {4, 4})
    assert BitGrid.total_lit == 9

    BitGrid.toggle({0,0}, {4,4})
    assert BitGrid.total_lit == 16
  end
end
