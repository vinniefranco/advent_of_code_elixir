defmodule AdventOfCode.Day10Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day10

  test "steps '1' to '11'" do
    assert Day10.look_and_say("1") == "11"
  end

  test "steps '11' to '21'" do
    assert Day10.look_and_say("11") == "21"
  end

  test "steps '21' to '1211'" do
    assert Day10.look_and_say("21") == "1211"
  end

  test "steps '1211' to '111221'" do
    assert Day10.look_and_say("1211") == "111221"
  end

  test "steps '111221' to '312211'" do
    assert Day10.look_and_say("111221") == "312211"
  end

end
