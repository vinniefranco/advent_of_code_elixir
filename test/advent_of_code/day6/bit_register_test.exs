defmodule AdventOfCode.Day6.BitRegisterTest do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day6.BitRegister

  setup do
    {:ok, pid} = BitRegister.start_link

    {:ok, pid: pid}
  end

  test "is 0 on init", %{pid: pid} do
    assert BitRegister.total_lit(pid) == 0
  end

  test "turns on specified bits", %{pid: pid} do
    operation = "110" |> String.to_integer(2)

    BitRegister.turn_on(pid, operation)

    assert BitRegister.total_lit(pid) == 2
    assert BitRegister.to_string(pid) == "110"
  end

  test "turns on specified bits leaving existing bits on", %{pid: pid} do
    operation = "101010" |> String.to_integer(2)
    BitRegister.turn_on(pid, operation)

    assert BitRegister.total_lit(pid) == 3

    operation = "010111" |> String.to_integer(2)
    BitRegister.turn_on(pid, operation)

    assert BitRegister.total_lit(pid) == 6
    assert BitRegister.to_string(pid) == "111111"
  end

  test "toggles specified bits on/off", %{pid: pid} do
    initial_state = "1010" |> String.to_integer(2)
    bits_to_toggle = "111" |> String.to_integer(2)

    BitRegister.turn_on(pid, initial_state)
    assert BitRegister.to_string(pid) == "1010"

    BitRegister.toggle(pid, bits_to_toggle)
    assert BitRegister.to_string(pid) == "1101"

    BitRegister.toggle(pid, bits_to_toggle)
    assert BitRegister.to_string(pid) == "1010"
  end

  test "turns off specified bits", %{pid: pid} do
    initial_state = "10011100111" |> String.to_integer(2)
    off_bits      = "00001111110" |> String.to_integer(2)
    expected      = "10010000001"

    BitRegister.turn_on(pid, initial_state)
    BitRegister.turn_off(pid, off_bits)

    assert BitRegister.to_string(pid) == expected
  end

end
