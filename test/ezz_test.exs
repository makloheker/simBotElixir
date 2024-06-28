defmodule EzzTest do
  use ExUnit.Case
  doctest Ezz

  test "greets the world" do
    assert Ezz.hello() == :world
  end
end
