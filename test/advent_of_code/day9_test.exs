defmodule AdventOfCode.Day9Test do
  use ExUnit.Case, aync: true

  alias AdventOfCode.Day9

  test "correctly generates a route table for use in recursion" do
    expected_output = %{
      "London" => %{
        "Dublin" => 464,
        "Belfast" => 518
      },
      "Belfast" => %{
        "London" => 518,
        "Dublin" => 141
      },
      "Dublin" => %{
        "Belfast" => 141,
        "London" => 464
      }
    }

    output = Day9.generate_route_table(
      "London to Dublin = 464\nLondon to Belfast = 518\nDublin to Belfast = 141"
    )

    assert output == expected_output
  end

  test "it finds the shortest path between all nodes" do
    {distance, _route} = Day9.shortest_path(
      "London to Dublin = 464\nLondon to Belfast = 518\nDublin to Belfast = 141"
    )

    assert distance == 605
  end

end
