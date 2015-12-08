defmodule AdventOfCode.Day6.BitRegister do
  use GenServer
  use Bitwise

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end

  def turn_on(pid, bits) do
    GenServer.cast(pid, {:turn_on, bits})
  end

  def turn_off(pid, bits) do
    GenServer.cast(pid, {:turn_off, bits})
  end

  def toggle(pid, bits) do
    GenServer.cast(pid, {:toggle, bits})
  end

  def total_lit(pid) do
    GenServer.call(pid, :total_lit)
  end

  def to_string(pid) do
    GenServer.call(pid, :to_string)
  end

  def init(:ok) do
    {:ok, 0}
  end

  def handle_cast({:turn_on, bits}, state) do
    {:noreply, state ||| bits}
  end

  def handle_cast({:turn_off, bits}, state) do
    {:noreply, state &&& ~~~bits}
  end

  def handle_cast({:toggle, bits}, state) do
    {:noreply, state ^^^ bits}
  end

  def handle_call(:total_lit, _from, state) do
    len =
      state
      |> Integer.to_string(2)
      |> String.replace("0", "")
      |> String.length

    {:reply, len, state}
  end

  def handle_call(:to_string, _from, state) do
    {:reply, Integer.to_string(state, 2), state}
  end

  def handle_call(request, from, state) do
    super(request, from, state)
  end
end
