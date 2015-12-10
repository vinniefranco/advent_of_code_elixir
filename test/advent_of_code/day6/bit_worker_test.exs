defmodule AdventOfCode.Day6.BitWorkerTest do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day6.BitWorker

  setup do
    {:ok, pid} = BitWorker.start_link

    {:ok, pid: pid}
  end

  test "is 0 on init", %{pid: pid} do
    assert BitWorker.total(pid) == 0
  end

  test "turns on specified bits", %{pid: pid} do
    operation = {1, 2}

    BitWorker.turn_on(pid, operation)

    assert BitWorker.total(pid) == 2
    assert BitWorker.to_string(pid) == "110"
  end

  test "turns on specified bits leaving existing bits on", %{pid: pid} do
    operation = {1, 2}
    BitWorker.turn_on(pid, operation)

    assert BitWorker.total(pid) == 2
    assert BitWorker.to_string(pid) == "110"

    operation = {0, 3}
    BitWorker.turn_on(pid, operation)

    assert BitWorker.total(pid) == 3
    assert BitWorker.to_string(pid) == "111"
  end

  test "toggles specified bits on/off", %{pid: pid} do
    BitWorker.turn_on(pid, {1, 1})
    BitWorker.turn_on(pid, {3, 1})

    assert BitWorker.to_string(pid) == "1010"

    BitWorker.toggle(pid, {0, 3})
    assert BitWorker.to_string(pid) == "1101"

    BitWorker.toggle(pid, {0, 3})
    assert BitWorker.to_string(pid) == "1010"
  end

  test "turns off specified bits", %{pid: pid} do
    BitWorker.turn_on(pid, {0, 8})
    BitWorker.turn_off(pid, {0, 4})

    assert BitWorker.to_string(pid) == "11110000"
  end

  test "turns off more specified bits", %{pid: pid} do
    BitWorker.turn_on(pid, {0, 2})
    assert BitWorker.to_string(pid) == "11"

    BitWorker.turn_off(pid, {0, 1})
    assert BitWorker.to_string(pid) == "10"

    BitWorker.toggle(pid, {0, 1})
    assert BitWorker.to_string(pid) == "11"
  end

end
