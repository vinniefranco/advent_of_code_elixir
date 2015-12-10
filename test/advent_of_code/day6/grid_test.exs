defmodule AdventOfCode.Day6.GridTest do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day6.Grid
  alias AdventOfCode.Day6.BitWorker
  alias AdventOfCode.Day6.HashWorker

  test "turn_on/2 HashWorker when given a start point and end point it turns on the correct bits" do
    Grid.start_link(HashWorker, 2)

    Grid.turn_on({0, 0}, {1, 1})
    assert Grid.total == 4

    Grid.turn_off({1,0}, {1,1})
    assert Grid.total == 2
  end

  test "turn_on/2 BitWorker when given a start point and end point it turns on the correct bits" do
    Grid.start_link(BitWorker, 5)

    Grid.turn_on({2, 2}, {4, 4})

    assert Grid.total == 9
  end

  test "turn_off/2 BitWorker when given a non-square operations it turns off the correct bits" do
    Grid.start_link(BitWorker, 5)

    Grid.turn_on({2, 2}, {4, 4})
    Grid.turn_off({2, 2}, {2, 4})

    assert Grid.total == 6
  end

  test "turn_off/2 HashWorker when given a non-square operations it turns off the correct bits" do
    Grid.start_link(HashWorker, 5)

    Grid.turn_on({2, 2}, {4, 4})
    assert Grid.total == 9

    Grid.turn_on({2, 2}, {4, 4})
    assert Grid.total == 18

    Grid.turn_off({2, 2}, {2, 4})
    assert Grid.total == 15

    Grid.turn_off({2, 2}, {4, 4})
    assert Grid.total == 6
  end

  test "turn_off/2 BitWorker when given start/end points it turns off the correct bits" do
    Grid.start_link(BitWorker, 5)

    Grid.turn_on({2, 2}, {4, 4})
    assert Grid.total == 9

    Grid.turn_off({3, 3}, {4, 4})
    assert Grid.total == 5
  end

  test "turn_off/2 HashWorker when given start/end points it turns off the correct bits" do
    Grid.start_link(HashWorker, 5)

    Grid.turn_on({2, 2}, {4, 4})
    assert Grid.total == 9

    Grid.turn_off({3, 3}, {4, 4})
    assert Grid.total == 5
  end

  test "toggle/2 BitWorker when given start/end points it toggle the correct bits" do
    Grid.start_link(BitWorker, 5)

    Grid.turn_on({2, 2}, {4, 4})
    assert Grid.total == 9

    Grid.toggle({0,0}, {4,4})
    assert Grid.total == 16
  end

  test "toggle/2 HashWorker when given start/end points it toggle the correct bits" do
    Grid.start_link(HashWorker, 2)

    Grid.turn_on({0, 0}, {1, 1})
    assert Grid.total == 4

    Grid.toggle({1,1}, {1,1})
    assert Grid.total == 6
  end

end
