defmodule AdventOfCode.Day6.BitWorker do
  use GenServer
  use Bitwise

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end

  def turn_on(pid, meta) do
    GenServer.cast(pid, {:turn_on, meta})
  end

  def turn_off(pid, meta) do
    GenServer.cast(pid, {:turn_off, meta})
  end

  def toggle(pid, meta) do
    GenServer.cast(pid, {:toggle, meta})
  end

  def total(pid) do
    GenServer.call(pid, :total)
  end

  def to_string(pid) do
    GenServer.call(pid, :to_string)
  end

  def init(:ok) do
    {:ok, 0}
  end

  def handle_cast({:turn_on, meta}, state) do
    bits = meta |> calc_bits
    {:noreply, state ||| bits}
  end

  def handle_cast({:turn_off, meta}, state) do
    bits = meta |> calc_bits
    {:noreply, state &&& ~~~bits}
  end

  def handle_cast({:toggle, meta}, state) do
    bits = meta |> calc_bits
    {:noreply, state ^^^ bits}
  end

  def handle_call(:total, _from, state) do
    len =
      state
      |> Integer.to_string(2) |> String.replace("0", "")
      |> String.length

    {:reply, len, state}
  end

  def handle_call(:to_string, _from, state) do
    {:reply, Integer.to_string(state, 2), state}
  end

  def handle_call(request, from, state) do
    super(request, from, state)
  end

  defp calc_bits({start, height}) do
    ((1 <<< height) - 1) <<< start
  end

end
