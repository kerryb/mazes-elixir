defmodule Mazes.BinaryTreeTest do
  use ExUnit.Case, async: true

  alias Mazes.{BinaryTree, Grid}
  doctest BinaryTree

  describe "Mazes.BinaryTree.on/1" do
    test "links all cells on the northern border" do
      grid = Grid.new(3, 3) |> BinaryTree.on()
      assert Grid.linked_east?(grid, {2, 0})
      assert Grid.linked_east?(grid, {2, 1})
    end

    test "links all cells on the eastern border" do
      grid = Grid.new(3, 3) |> BinaryTree.on()
      assert Grid.linked_north?(grid, {0, 2})
      assert Grid.linked_north?(grid, {1, 2})
    end

    test "links all other cells to either the north or east" do
      grid = Grid.new(3, 3) |> BinaryTree.on()

      for row <- [0, 1], column <- [0, 1] do
        assert Grid.linked_north?(grid, {row, column}) or Grid.linked_east?(grid, {row, column})
      end
    end
  end
end
