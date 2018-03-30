defmodule Fib do
  @moduledoc """
  Documentation for Fib.
  """
  alias Fib.Calculator
  defdelegate find(x), to: Calculator
end
