defmodule AdventOfCode.Day6.Grid do
  use GenServer

  def start_link(worker_type, width) do
    GenServer.start_link(__MODULE__, {:ok, {worker_type,width}}, name: __MODULE__)
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

  def total do
    GenServer.call(__MODULE__, :total, 100_000)
  end

  def to_string do
    GenServer.call(__MODULE__, :to_string, 100_000)
  end

  defp run_action(action, start_pos, end_pos) do
    GenServer.cast(__MODULE__, {action, {start_pos, end_pos}})
  end

  def init({:ok, {worker_type, width}}) do
    pids =
      (0..width - 1)
      |> Enum.map(
        fn (_) ->
          {:ok, pid} = worker_type.start_link
          pid
        end
      )

    {:ok, {pids, worker_type}}
  end

  def handle_cast({action, meta}, state) do
    meta |> extract_values |> execute_action(action, state)

    {:noreply, state}
  end

  def handle_call(:total, _from, state) do
    {pids, worker_type} = state

    curr_total = pids |> Enum.reduce(0, &(&2 + worker_type.total(&1)))

    {:reply, curr_total, state}
  end

  def handle_call(:to_string, _from, state) do
    {pids, worker_type} = state

    pids |> Enum.each(fn (pid) -> IO.puts worker_type.to_string(pid) end)

    {:reply, "sweet", state}
  end

  def handle_call(request, from, state) do
    super(request, from, state)
  end

  defp execute_action({from, width, height, start_y}, action, state) do
    {pids, worker_type} = state

    pids
    |> Enum.drop(from)
    |> Enum.take(width)
    |> Enum.each(&( apply(worker_type, action, [&1, {start_y, height}]) ))
  end

  defp extract_values({{start_x, start_y}, {end_x, end_y}}) do
    width  = end_x - start_x + 1
    height = end_y - start_y + 1

    {start_x, width, height, start_y}
  end
end
