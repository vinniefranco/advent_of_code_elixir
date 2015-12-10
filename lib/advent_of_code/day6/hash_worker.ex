defmodule AdventOfCode.Day6.HashWorker do
  use GenServer

  # Client methods
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
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

  # Server methods
  def init(:ok) do
    {:ok, HashDict.new}
  end

  def handle_cast({action, meta}, state) do
    new_state = meta |> get_range |> update_dict_with_action(state, action)

    {:noreply, new_state}
  end

  def handle_call(:total, _from, state) do
    curr_total = state |> HashDict.values |> Enum.reduce(0, &(&2 + &1))

    {:reply, curr_total, state}
  end

  def handle_call(request, from, state) do
    super(request, from, state)
  end

  defp update_dict_with_action(range, state, action) do
    {default_val, update_fn} = action |> get_update_actions

    range
    |> Enum.reduce(state, &(HashDict.update(&2, &1, default_val, update_fn)))
  end

  defp get_update_actions(:turn_on) do
    {1, fn val -> val + 1 end}
  end

  defp get_update_actions(:turn_off) do
    {0, fn val -> max(0, val - 1) end}
  end

  defp get_update_actions(:toggle) do
    {2, fn val -> val + 2 end}
  end

  defp get_range({start, len}) do
    (start..start + len - 1)
  end

end
