defmodule FibCache do
  @moduledoc """
  Documentation for FibCache.
  """
  alias FibCache.State
  defdelegate get(x),           to: State
  defdelegate update(x, value), to: State
end
