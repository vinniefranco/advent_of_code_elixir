defmodule AdventOfCode.Day6.HashWorkerTest do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day6.HashWorker

  setup do
    {:ok, pid} = HashWorker.start_link

    {:ok, pid: pid}
  end

  test "is 0 on init", %{pid: pid} do
    assert HashWorker.total(pid) == 0
  end

  test "turn_on/2 plus ones a range of keys", %{pid: pid} do
    HashWorker.turn_on(pid, {0, 5})
    assert HashWorker.total(pid) == 5

    HashWorker.turn_on(pid, {0, 5})
    assert HashWorker.total(pid) == 10

    HashWorker.turn_on(pid, {4, 1})
    assert HashWorker.total(pid) == 11
  end

  test "turn_off/2 plus ones a range of keys", %{pid: pid} do
    HashWorker.turn_on(pid, {0, 8})
    assert HashWorker.total(pid) == 8

    HashWorker.turn_off(pid, {0, 4})
    assert HashWorker.total(pid) == 4

    HashWorker.turn_off(pid, {5, 2})
    assert HashWorker.total(pid) == 2
  end

  test "turn_off/2 has a zero floor", %{pid: pid} do
    HashWorker.turn_off(pid, {0, 8})
    HashWorker.turn_off(pid, {0, 8})

    assert HashWorker.total(pid) == 0
  end

  test "toggle/2 increases total by 2", %{pid: pid} do
    HashWorker.turn_on(pid, {0, 2})
    assert HashWorker.total(pid) == 2

    HashWorker.toggle(pid, {1, 2})
    assert HashWorker.total(pid) == 6
  end

end
