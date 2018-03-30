defmodule SolverTest do
  use ExUnit.Case
  doctest Solver

  test "greets the world" do
    assert Solver.hello() == :world
  end
end
