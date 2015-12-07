defmodule AdventOfCode.Day5 do
  @doc ~S"""
    Day 5: Doesn't He Have Intern-Elves For This? ---

    Santa needs help figuring out which strings in his text file are naughty or nice.

    A nice string is one with all of the following properties:

    It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
    It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
    It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
    For example:

    ugknbfddgicrmopn is nice because it has at least three vowels (u...i...o...), a double letter (...dd...), and none of the disallowed substrings.
    aaa is nice because it has at least three vowels and a double letter, even though the letters used by different rules overlap.
    jchzalrnumimnmhp is naughty because it has no double letter.
    haegwjzuvuyypxyu is naughty because it contains the string xy.
    dvszwmarrgswjxmb is naughty because it contains only one vowel.

  """

  def how_many_nice_redux(strs) do
    Enum.filter(strs, &string_is_really_nice/1) |> length
  end

  def how_many_nice(strs) do
    Enum.filter(strs, &string_is_nice/1) |> length
  end

  def string_is_really_nice(str) do
    str |> matches_rules([:one_tripled_pair?, :contains_palindrome?])
  end

  def string_is_nice(str) do
    str |> matches_rules([:one_doubled_char?, :contains_3_vowels?, :no_bad_substrings?])
  end

  defp matches_rules(str, rules) do
    rules |> Enum.reduce(true, &(&2 && apply(__MODULE__, &1, [str])))
  end

  defp one_doubled_char?(str) do
    Regex.match?(~r/([a-z])\1{1}/, str)
  end

  defp one_tripled_pair?(str) do
    Regex.match?(~r/(\w{2}).*\1+/, str)
  end

  defp contains_palindrome?(str) do
    Regex.match?(~r/(\w).\1/, str)
  end

  defp contains_3_vowels?(str) do
    Regex.match?(~r/(.*[aeiou]){3}/, str)
  end

  defp no_bad_substrings?(str) do
    !Regex.match?(~r/ab|cd|pq|xy/, str)
  end
end
