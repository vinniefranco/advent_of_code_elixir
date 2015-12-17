defmodule AdventOfCode.Day9 do

  def generate_route_table(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, &(extract_map(&2 ,&1)))
  end

  def shortest_path(input) do
    input
    |> generate_route_table
    |> traverse_route
  end

  defp traverse_route(map) do
    places = map |> Dict.keys
    start_location = List.first(places)
    max_steps = length(places)

    step(map, start_location, max_steps, 0, [start_location], {0, []})
  end

  defp step(map, cur_node, max_steps, distance, traveled, p_acc) when length(traveled) < max_steps do
    map
    |> Dict.get(cur_node)
    |> Dict.drop(traveled)
    |> Enum.reduce(p_acc, fn ({key, val}, acc) ->
      step(map, key, max_steps, distance + val, [key | traveled], acc)
    end)
  end

  defp step(_map, _, _max_steps, distance, traveled, other_route) do
    min_traveled({distance, traveled}, other_route)
  end

  defp min_traveled(a, {0, []}) do
    a
  end

  defp min_traveled({a_dis, _a_traveled} = a, {b_dis, _b_traveled}) when a_dis < b_dis do
    a
  end

  defp min_traveled(_a, b) do
    b
  end

  defp extract_map(acc, line) do
    line
    |> String.split(" ")
    |> List.to_tuple
    |> to_map(acc)
  end

  defp to_map({d1, _to, d2, _equals, distance}, acc) do
    {_, new_map} =
      acc
      |> Dict.update(d1, %{}, &(&1))
      |> Dict.update(d2, %{}, &(&1))
      |> get_and_update_in([d1, d2], &{&1, distance |> String.to_integer})
      |> Tuple.to_list
      |> Enum.at(1)
      |> get_and_update_in([d2, d1], &{&1, distance |> String.to_integer})

    new_map
  end

end
