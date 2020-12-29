# credo:disable-for-this-file Credo.Check.Readability.SinglePipe
# credo:disable-for-this-file Credo.Check.Refactor.PipeChainStart

defmodule Mazes.Algorithms.BinaryTreeTest do
  use ExUnit.Case, async: true
  import AssertValue

  alias Mazes.Algorithms.BinaryTree
  alias Mazes.Grid

  doctest BinaryTree

  describe "Mazes.BinaryTree.on/1" do
    test "generates a maze" do
      :rand.seed(:exrop, {101, 102, 103})
      grid = BinaryTree.on(Grid.new(5, 5))

      assert_value inspect(grid) == """
                   +---+---+---+---+---+
                   |                   |
                   +---+---+   +   +   +
                   |           |   |   |
                   +   +---+---+   +   +
                   |   |           |   |
                   +   +---+---+---+   +
                   |   |               |
                   +   +   +---+   +   +
                   |   |   |       |   |
                   +---+---+---+---+---+
                   """
    end
  end
end
