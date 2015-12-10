defmodule AdventOfCode.Day7.MachineTest do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day7.Machine

  test "assigns var into the when var is a digit" do
    {env, _queue} = Machine.run(%{}, [ {"123", "->", "x"} ])

    assert %{"x" => 123} == env
  end

  test "execute NOT as bitwise when var is in the env" do
    {env, _queue} = Machine.run(%{"x" => 123}, [ {"NOT", "x", "->", "y"} ])

    assert %{"x" => 123, "y" => 65412} == env
  end

  test "NOT enqueues when var is not in env" do
    {_env, queue} = Machine.run(%{}, [ {"NOT", "x", "->", "y"} ])

    assert [{"NOT", "x", "->", "y"}] == queue
  end

  test "parse_instruction AND assigns bitwise AND to assign when both vars exist" do
    initial_env = %{"a" => 2, "b" => 3}

    {env, _queue} = Machine.run(initial_env, [ {"a", "AND", "b", "->", "c"} ])

    assert %{"a" => 2, "b" => 3, "c" => 2} == env
  end

  test "parse_instruction AND adds to queue when left is missing" do
    initial_queue = [ {"a", "AND", "b", "->", "c"} ]

    {_env ,new_queue} = Machine.run(%{"b" => 3}, initial_queue)

    assert new_queue == initial_queue
  end

  test "parse_instruction AND adds to queue when right is missing" do
    initial_queue = [ {"a", "AND", "b", "->", "c"} ]

    {_env, new_queue} = Machine.run(%{"a" => 3}, initial_queue)

    assert new_queue == initial_queue
  end

  test "OR assigns bitwise | to env when both vars exist" do
    {env, _queue} = Machine.run(%{"a" => 2 , "b" => 3}, [ {"a", "OR", "b", "->", "c"} ])

    assert %{"a" => 2, "b" => 3, "c" => 3} == env
  end

  test "OR is enqueued when left is missing" do
    initial_queue = [ {"a", "OR", "b", "->", "c"} ]

    {_env, new_queue} = Machine.run(%{"b" => 3}, initial_queue)

    assert new_queue == initial_queue
  end

  test "OR is enqueued when right is missing" do
    initial_queue = [ {"a", "OR", "b", "->", "c"} ]

    {_env, new_queue} = Machine.run(%{"a" => 3}, initial_queue)

    assert new_queue == initial_queue
  end

  test " LSHIFT assigns bitwise << to assign when envar exists" do
    queue = [ {"a", "LSHIFT", "2", "->", "b"} ]

    {env, _queue} = Machine.run(%{"a" => 2}, queue)

    assert %{"a" => 2, "b" => 8} == env
  end

  test "LSHIFT adds to queue when envar is missing" do
    initial_queue = [ {"a", "LSHIFT", "2", "->", "b"} ]

    {_env, new_queue} = Machine.run(%{}, initial_queue)

    assert new_queue == initial_queue
  end

  test "parse_instruction RSHIFT assigns bitwise >> to assign when envar exists" do
    queue = [ {"a", "RSHIFT", "1", "->", "b"} ]

    {env, _queue} = Machine.run(%{"a" => 8}, queue)

    assert %{"a" => 8, "b" => 4} == env
  end

  test "parse_instruction RSHIFT adds to queue when envar is missing" do
    initial_queue = [ {"a", "RSHIFT", "1", "->", "b"} ]

    {_env, new_queue} = Machine.run(%{}, initial_queue)

    assert new_queue == initial_queue
  end

  test "run moves enqueues unprocessable instructions" do
    initial_queue =[
      {"a", "AND", "b", "->", "x"},
      {"1", "->", "a"},
      {"3", "->", "b"}
    ]
    {env, queue} = Machine.run(%{}, initial_queue)

    assert queue == [
      {"1", "->", "a"},
      {"3", "->", "b"},
      {"a", "AND", "b", "->", "x"}
    ]

    {env, queue} = Machine.run(env, queue)
    assert queue == [ {"3", "->", "b"}, {"a", "AND", "b", "->", "x"} ]
    assert env == %{"a" => 1}

    {env, queue} = Machine.run(env, queue)

    assert queue == [ {"a", "AND", "b", "->", "x"} ]
    assert env == %{"a" => 1 ,"b" => 3}
  end

end
