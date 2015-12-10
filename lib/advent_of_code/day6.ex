defmodule AdventOfCode.Day6 do
  alias AdventOfCode.Day6.Grid

  def execute_operations(worker_type, operations) do
    Grid.start_link(worker_type, 1_000)

    operations |> Enum.each(&(execute_operation &1))

    Grid.total
  end

  def execute_operation(operation) do
    operation |> parse_operation |> execute
  end

  @doc ~S"""
      iex> AdventOfCode.Day6.parse_operation("turn on 0,0 through 999,999")
      { :turn_on, {0, 0}, {999, 999} }
  """
  def parse_operation("turn on" <> rest) do
    rest |> get_movement(:turn_on)
  end

  def parse_operation("turn off" <> rest) do
    rest |> get_movement(:turn_off)
  end

  def parse_operation("toggle" <> rest) do
    rest |> get_movement(:toggle)
  end

  def get_movement(operation, action) do
    [ _ | coords ]= Regex.run(~r/(\d+),(\d+) through (\d+),(\d+)/, operation)

    [start_at, end_at] =
      coords
      |> Enum.chunk(2)
      |> Enum.map(
        fn ([a,b]) -> { String.to_integer(a), String.to_integer(b) } end
      )

    { action, start_at, end_at }
  end

  defp execute({action, start_at, end_at}) do
    apply(Grid, action, [start_at, end_at])
  end

end
