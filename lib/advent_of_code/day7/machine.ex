defmodule AdventOfCode.Day7.Machine do
  use Bitwise

  @bit_ceil 65536

  def run(env, [instruction | rest]) do
    parse(env, instruction, rest)
  end

  def run(env, []) do
    {env, []}
  end

  defp parse(env, {opr, env_var, "->", var} = op, instructions) do
    update_env(env, var, op, op_fn_for(opr).(values(env, [env_var])), instructions)
  end

  defp parse(env, {a, opr, b, "->", var} = op, instructions) do
    update_env(env, var, op, op_fn_for(opr).(values(env, [a, b])), instructions)
  end

  defp parse(env, {val, opr, var} = op, instructions) do
    update_env(env, var, op, op_fn_for(opr).(values(env, [val])), instructions)
  end

  defp update_env(env, var, op, val_fn, instructions) do
    try do
      {Dict.put(env, var, val_fn.()), instructions}
    rescue
      ArithmeticError -> {env, instructions ++ [op]}
    end
  end

  defp values(env, env_vars) do
    env_vars
    |> Enum.map(&(value(env, &1, Integer.parse(&1))))
    |> List.to_tuple
  end

  defp value(_env, _var, {int, _}), do: int
  defp value(env, var, :error),     do: Dict.get(env, var)

  defp wrap(x) when x > 0, do: rem(x, @bit_ceil)
  defp wrap(x) when x < 0, do: rem(@bit_ceil + x, @bit_ceil)
  defp wrap(0),            do: 0

  defp op_fn_for("->"),     do: fn ({a}) -> fn -> a + 0 end end
  defp op_fn_for("AND"),    do: fn ({a, b}) -> fn -> band(a, b) end end
  defp op_fn_for("NOT"),    do: fn {val} -> fn -> val |> bnot |> wrap end end
  defp op_fn_for("OR"),     do: fn ({a, b}) -> fn -> bor(a, b) end end
  defp op_fn_for("LSHIFT"), do: fn ({a, b}) -> fn -> bsl(a, b) end end
  defp op_fn_for("RSHIFT"), do: fn ({a, b}) -> fn -> bsr(a, b) end end

end
