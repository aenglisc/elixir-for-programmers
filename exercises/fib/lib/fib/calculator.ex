defmodule Fib.Calculator do
  import FibCache

  def find(x) do
    calc(x, get(x))
  end

  defp calc(x, _value = nil) do
    update(x, calc(x - 1, get(x - 1)) + calc(x - 2, get(x - 2)))
    get(x)
  end

  defp calc(_x, value), do: value
end
