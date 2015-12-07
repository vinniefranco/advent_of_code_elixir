defmodule AdventOfCode.Day4 do
  @doc ~S"""
  Day 4: The Ideal Stocking Stuffer ---

  Santa needs help mining some AdventCoins (very similar to bitcoins)
  to use as gifts for all the economically forward-thinking little girls and boys.

  To do this, he needs to find MD5 hashes which, in hexadecimal,
  start with at least five zeroes. The input to the MD5 hash is
  some secret key (your puzzle input, given below) followed by
  a number in decimal. To mine AdventCoins, you must find Santa
  the lowest positive number (no leading zeroes: 1, 2, 3, ...)
  that produces such a hash.

  For example:

  If your secret key is abcdef, the answer is 609043,
  because the MD5 hash of abcdef609043 starts with five zeroes (000001dbbfa...),
  and it is the lowest such number to do so.

  If your secret key is pqrstuv, the lowest number it combines with
  to make an MD5 hash starting with five zeroes is 1048970; that is,
  the MD5 hash of pqrstuv1048970 looks like 000006136ef....

    iex> AdventOfCode.Day4.pmine("abcdef", 10)
    609043

  """
  def mine(secret) do
    "#{secret}0" |> md5_hash |> crack secret, 0
  end

  defp crack("00000" <> _rest, _secret, num) do
    num
  end

  defp crack(_hash, secret, num) do
    "#{secret}#{num + 1}" |> md5_hash |> crack secret, num + 1
  end

  @doc ~S"""
    Let's introduce multi-processing here...
  """
  def pmine(secret, n_workers) do
    parent = self
    chunk = div(1_000_000, n_workers)

    1..n_workers |> Enum.map(fn n ->
      Task.start fn -> pcrack(secret, {chunk * (n - 1), chunk * n}, parent) end
    end)

    receive_work
  end

  defp receive_work do
    receive do
      {:ok, num} -> num
      {:empty, _msg} -> receive_work
    end
  end

  def pcrack(secret, {start, stop}, pid) do
    "#{secret}#{start}" |> md5_hash |> pcrack(secret, {start, stop}, pid)
  end

  defp pcrack("00000" <> _rest, _secret, {num, _stop}, pid) do
    send pid, {:ok, num}
  end

  defp pcrack(_hash, secret, {num, stop}, pid) when num <= stop do
    "#{secret}#{num + 1}" |> md5_hash |> pcrack(secret, {num + 1, stop}, pid)
  end

  defp pcrack(_hash, _secret, { _num, _stop}, pid) do
    send pid, {:empty, "Not found"}
  end

  defp md5_hash(str) do
    :crypto.hash(:md5, str) |> Base.encode16
  end
end
