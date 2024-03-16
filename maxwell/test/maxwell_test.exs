defmodule MaxwellTest do
  use ExUnit.Case
  doctest Maxwell

  test "greets the world" do
    assert Maxwell.hello() == :world
  end
end
