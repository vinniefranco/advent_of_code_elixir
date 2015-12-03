defmodule AdventOfCode.Day2 do
  @doc ~S"""
  Day 2: I Was Told There Would Be No Math

  The elves are running low on wrapping paper, and so they need to submit
  an order for more.

  They have a list of the dimensions (length l, width w, and height h)
  of each present, and only want to order exactly as much as they need.

  Fortunately, every present is a box (a perfect right rectangular prism),
  which makes calculating the required wrapping paper for each gift
  a little easier:

  find the surface area of the box, which is 2*l*w + 2*w*h + 2*h*l.
  The elves also need a little extra paper for each present: the area of the smallest side.

  Example:

    # A present with dimensions 2x3x4 requires 2*6 + 2*12 + 2*8 = 52
    # square feet of wrapping paper plus 6 square feet of slack,
    # for a total of 58 square feet.

    iex> AdventOfCode.Day2.sqft_of_paper_for_package("2x3x4")
    58

    # A present with dimensions 1x1x10 requires 2*1 + 2*10 + 2*10 = 42
    # square feet of wrapping paper plus 1 square foot of slack,
    # for a total of 43 square feet.

    iex> AdventOfCode.Day2.sqft_of_paper_for_package("1x1x10")
    43

  """
  def sqft_of_paper_for_package(dimensions) do
    dimensions |> dimensions_from_str |> calculate_total_paper
  end

  @doc ~S"""
    Same as above but for lists!

    Example:

      iex> AdventOfCode.Day2.sqft_of_paper_for_packages(["2x3x4", "1x1x10"])
      101
  """
  def sqft_of_paper_for_packages(list_of_packages) do
    list_of_packages |> reduce_with(&sqft_of_paper_for_package/1)
  end

  @doc ~S"""
    Part Two

    The elves are also running low on ribbon. Ribbon is all the same width,
    so they only have to worry about the length they need to order,
    which they would again like to be exact.

    The ribbon required to wrap a present is the shortest distance
    around its sides, or the smallest perimeter of any one face.
    Each present also requires a bow made out of ribbon as well;
    the feet of ribbon required for the perfect bow is equal to
    the cubic feet of volume of the present.

    Don't ask how they tie the bow, though; they'll never tell.

    Example:

      # A present with dimensions 2x3x4 requires 2+2+3+3 = 10 feet of ribbon
      # to wrap the present plus 2*3*4 = 24 feet of ribbon for the bow, for a total of 34 feet.

      iex> AdventOfCode.Day2.ft_of_ribbon_for_package("2x3x4")
      34

      # A present with dimensions 1x1x10 requires 1+1+1+1 = 4 feet of ribbon
      # to wrap the present plus 1*1*10 = 10 feet of ribbon for the bow, for a total of 14 feet

      iex> AdventOfCode.Day2.ft_of_ribbon_for_package("1x1x10")
      14

  """
  def ft_of_ribbon_for_package(dimensions) do
    dimensions |> dimensions_from_str |> ribbon_for_package |> ribbon_for_bow
  end

  @doc ~S"""
    Same as above but for lists!

    Example:

      iex> AdventOfCode.Day2.ft_of_ribbon_for_packages(["2x3x4", "1x1x10"])
      48

  """
  def ft_of_ribbon_for_packages(list_of_packages) do
    list_of_packages |> reduce_with(&ft_of_ribbon_for_package/1)
  end

  def surface_area_of_cuboid(a, b , c) do
    (2 * a * b) + (2 * a * c) + (2 * b * c)
  end

  defp reduce_with(list, func) do
    list |> Enum.reduce(0, &(&2 + func.(&1)))
  end

  defp ribbon_for_package(dimensions) do
    ribbon = dimensions |> Enum.take(2) |> Enum.sum

    {ribbon * 2, dimensions}
  end

  defp ribbon_for_bow({ribbon, dimensions}) do
    bow = dimensions |> Enum.reduce(fn(side, acc) -> side * acc end)

    ribbon + bow
  end

  defp dimensions_from_str(dimensions) do
    dimensions
    |> String.split("x")
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort
  end

  defp calculate_total_paper([a, b, c]) do
    surface_area_of_cuboid(a, b, c) + (a * b)
  end
end
