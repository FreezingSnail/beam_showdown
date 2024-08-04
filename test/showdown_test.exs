defmodule BasicProjectTest do
  use ExUnit.Case

  test "can call Elixir code" do
    assert Showdown.hello() == :world
  end

  test "can call Gleam code" do
    assert :basic_project.hello() == :world
  end

  test "can call Gleam library" do
    assert :gleam@list.reverse([1, 2, 3]) == [3, 2, 1]
  end
end
