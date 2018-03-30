defmodule Solver do
  @moduledoc """
  Documentation for Solver.
  """
  defdelegate start, to: Solver.Logic
end
