# credo:disable-for-this-file Credo.Check.Design.DuplicatedCode
# credo:disable-for-this-file Credo.Check.Refactor.PipeChainStart

defmodule Mazes.Solver.DistancesTest do
  use ExUnit.Case, async: true

  alias Mazes.Algorithms.BinaryTree
  alias Mazes.Grid
  alias Mazes.Solver.Distances

  doctest Distances

  describe "Mazes.Solver.Distances.calculate/2" do
    test "sets the origin" do
      grid = Grid.new(3, 3) |> BinaryTree.on() |> Distances.calculate({1, 1})
      assert grid.origin == {1, 1}
    end

    test "calculates the distance of each cell from the supplied origin" do
      grid =
        Grid.new(3, 3)
        |> Grid.link_north({0, 0})
        |> Grid.link_east({0, 1})
        |> Grid.link_north({0, 2})
        |> Grid.link_east({1, 0})
        |> Grid.link_north({1, 1})
        |> Grid.link_north({1, 2})
        |> Grid.link_east({2, 0})
        |> Grid.link_east({2, 1})
        |> Distances.calculate({0, 0})

      # +---+---+---+
      # | 4   3   4 |
      # +---+   +   +
      # | 1   2 | 5 |
      # +   +---+   +
      # | 0 | 7   6 |
      # +---+---+---+
      assert grid.distances == %{
               {0, 0} => 0,
               {0, 1} => 7,
               {0, 2} => 6,
               {1, 0} => 1,
               {1, 1} => 2,
               {1, 2} => 5,
               {2, 0} => 4,
               {2, 1} => 3,
               {2, 2} => 4
             }
    end
  end
end
