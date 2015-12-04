defmodule AdventOfCode.Day3 do
  @doc ~S"""
    Day 3: Perfectly Spherical Houses in a Vacuum

    Santa is delivering presents to an infinite two-dimensional grid of houses.

    He begins by delivering a present to the house at his starting location,
    and then an elf at the North Pole calls him via radio and tells him where to move next.
    Moves are always exactly one house to the north (^), south (v), east (>), or west (<).
    After each move, he delivers another present to the house at his new location.

    However, the elf back at the north pole has had a little too much eggnog,
    and so his directions are a little off, and Santa ends up visiting
    some houses more than once. How many houses receive at least one present?

    Example:

      # > delivers presents to 2 houses: one at the starting location,
      # and one to the east.

      iex> AdventOfCode.Day3.execute_delivery_instructions(">")
      2

      # ^>v< delivers presents to 4 houses in a square, including twice
      # to the house at his starting/ending location.

      iex> AdventOfCode.Day3.execute_delivery_instructions("^>v<")
      4

      # ^v^v^v^v^v delivers a bunch of presents to some
      # very lucky children at only 2 houses.

      iex> AdventOfCode.Day3.execute_delivery_instructions("^v^v^v^v^v")
      2

  """
  def execute_delivery_instructions(instructions) do
    instructions |> visited_coords |> length
  end

  @doc ~S"""
    Part Two

    The next year, to speed up the process,
    Santa creates a robot version of himself, Robo-Santa,
    to deliver presents with him.

    Santa and Robo-Santa start at the same location
    (delivering two presents to the same starting house), then take turns
    moving based on instructions from the elf, who is eggnoggedly reading
    from the same script as the previous year.

    This year, how many houses receive at least one present?

    For example:

      # ^v delivers presents to 3 houses, because Santa goes north,
      # and then Robo-Santa goes south.
      iex> AdventOfCode.Day3.execute_robotizied_delivery_instructions("^v")
      3

      # ^>v< now delivers presents to 3 houses, and Santa
      # and Robo-Santa end up back where they started.
      iex> AdventOfCode.Day3.execute_robotizied_delivery_instructions("^>v<")
      3

      # ^v^v^v^v^v now delivers presents to 11 houses, with Santa going
      # one direction and Robo-Santa going the other.
      iex> AdventOfCode.Day3.execute_robotizied_delivery_instructions("^v^v^v^v^v")
      11

  """
  def execute_robotizied_delivery_instructions(instructions) do
    santas_visits =
      instructions
      |> filter_instructions_by(fn ({_move, index}) -> rem(index, 2) == 0 end)
      |> visited_coords

    robo_visits =
      instructions
      |> filter_instructions_by(fn ({_move, index}) -> rem(index, 2) != 0 end)
      |> visited_coords

    santas_visits |> Enum.concat(robo_visits) |> Enum.uniq |> length
  end

  defp filter_instructions_by(instructions, filter) do
    instructions
    |> String.split("", trim: true)
    |> Enum.with_index
    |> Enum.filter(filter)
    |> Enum.map(fn ({move, _index}) -> move end)
    |> Enum.join("")
  end


  defp visited_coords(directions, grid \\ %{"0:0" => 1}, pos \\ {0, 0}) do
    on_direction(directions, grid, pos)
  end

  defp on_direction("", grid, _pos) do
    grid |> Dict.keys
  end

  defp on_direction(">" <> rest, grid, {row, col}) do
    pos = {row, col + 1}
    on_direction(rest, update_grid(grid, pos), pos)
  end

  defp on_direction("<" <> rest, grid, {row, col}) do
    pos = {row, col - 1}
    on_direction(rest, update_grid(grid, pos), pos)
  end

  defp on_direction("^" <> rest, grid, {row, col}) do
    pos = {row + 1, col}
    on_direction(rest, update_grid(grid, pos), pos)
  end

  defp on_direction("v" <> rest, grid, {row, col}) do
    pos = {row - 1, col}
    on_direction(rest, update_grid(grid, pos), pos)
  end

  defp update_grid(grid, pos) do
    key = pos |> Tuple.to_list |> Enum.join(":")

    Dict.update(grid, key, 1, &(&1 + 1))
  end
end
