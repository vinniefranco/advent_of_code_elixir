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

  def parse_operation(operation) do
    [ _, _, c1, c2 | coords ] =
      Regex.run(~r/((\w+)(?:\s(\w+))?)\s(\d+),(\d+)\sthrough\s(\d+),(\d+)/, operation)

    action = [c1, c2] |> Enum.join("_") |> String.replace(~r/_$/, "") |> String.to_atom

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
