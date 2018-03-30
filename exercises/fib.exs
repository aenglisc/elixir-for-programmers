defmodule Fib do
  import FibCache

  def fib(x) do
    {:ok, pid} = init_cache()
    calc(pid, x, get(pid, x))
  end
  
  defp calc(pid, x, _value = nil) do
    update(pid, x, calc(pid, x-1, get(pid, x-1)) + calc(pid, x-2, get(pid, x-2)))
    get(pid, x)
  end
  defp calc(_pid, _x, value), do: value
end