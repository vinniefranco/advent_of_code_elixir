defmodule AdventOfCode.Day6.BitGrid do
  use GenServer
  use Bitwise

  alias AdventOfCode.Day6.BitRegister

  def start_link(width) do
    GenServer.start_link(__MODULE__, {:ok, width}, name: __MODULE__)
  end

  def turn_on(start_pos, end_pos) do
    run_action(:turn_on, start_pos, end_pos)
  end

  def turn_off(start_pos, end_pos) do
    run_action(:turn_off, start_pos, end_pos)
  end

  def toggle(start_pos, end_pos) do
    run_action(:toggle, start_pos, end_pos)
  end

  def total_lit do
    GenServer.call(__MODULE__, :total_lit)
  end

  defp run_action(action, start_pos, end_pos) do
    GenServer.cast(__MODULE__, {action, {start_pos, end_pos}})
  end

  def init({:ok, width}) do
    pids =
      (0..width - 1)
      |> Enum.map(
        fn (_) ->
          {:ok, pid} = BitRegister.start_link
          pid
        end
      )

    {:ok, pids}
  end

  def handle_cast({:turn_on, {start_pos, end_pos}}, pids) do
    bit_rules = bit_width(start_pos, end_pos)
    twiddle_bits(:turn_on, bit_rules, pids)

    {:noreply, pids}
  end

  def handle_cast({:turn_off, {start_pos, end_pos}}, pids) do
    bit_rules = bit_width(start_pos, end_pos)
    twiddle_bits(:turn_off, bit_rules, pids)

    {:noreply, pids}
  end

  def handle_cast({:toggle, {start_pos, end_pos}}, pids) do
    bit_rules = bit_width(start_pos, end_pos)
    twiddle_bits(:toggle, bit_rules, pids)

    {:noreply, pids}
  end

  def handle_call(:total_lit, _from, pids) do
    total = pids |> Enum.reduce(0, &(&2 + BitRegister.total_lit(&1)))

    {:reply, total, pids}
  end

  def handle_call(request, from, state) do
    super(request, from, state)
  end

  defp twiddle_bits(action, {from, width, bits}, pids) do
    pids
    |> Enum.drop(from)
    |> Enum.take(width)
    |> Enum.each(&( apply(BitRegister, action, [&1, bits]) ))
  end

  defp bit_width({start_x, start_y}, {end_x, end_y}) do
    width = end_x - start_x + 1
    bits = ((1 <<< (end_y - start_y + 1)) - 1) <<< start_y

    {start_x, width, bits}
  end
end
