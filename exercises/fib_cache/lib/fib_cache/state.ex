defmodule FibCache.State do
  @me __MODULE__
  def start_link,       do: Agent.start_link(fn -> %{0 => 0, 1 => 1} end, name: @me)
  def get(x),           do: Agent.get(@me, &(&1[x]))
  def update(x, value), do: Agent.update(@me, &Map.put(&1, x, value))
end