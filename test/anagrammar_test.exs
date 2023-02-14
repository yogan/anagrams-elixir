defmodule AnagrammarTest do
  use ExUnit.Case
  doctest Anagrammar

  test "greets the world" do
    assert Anagrammar.hello() == :world
  end
end
