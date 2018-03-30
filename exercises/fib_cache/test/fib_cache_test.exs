defmodule FibCacheTest do
  use ExUnit.Case
  doctest FibCache

  test "greets the world" do
    assert FibCache.hello() == :world
  end
end
