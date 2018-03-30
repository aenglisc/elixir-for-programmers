defmodule FibCache do
  def init_cache,  do: Agent.start_link(fn -> %{0 => 0, 1 => 1} end)
  def get(pid, x), do: Agent.get(pid, &(&1[x]))
  def update(pid, x, value), do: Agent.update(pid, &Map.put(&1, x, value))
end