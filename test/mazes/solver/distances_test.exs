# credo:disable-for-this-file Credo.Check.Refactor.PipeChainStart

defmodule Mazes.Solver.DistancesTest do
  use ExUnit.Case, async: true
  import AssertValue

  alias Mazes.Algorithms.Sidewinder
  alias Mazes.Grid
  alias Mazes.Solver.Distances

  doctest Distances

  describe "Mazes.Solver.Distances.calculate/2" do
    test "sets the origin" do
      grid = Grid.new(3, 3) |> Sidewinder.on() |> Distances.calculate({1, 1})
      assert grid.origin == {1, 1}
    end

    test "calculates the distance of each cell from the supplied origin" do
      :rand.seed(:exrop, {101, 102, 103})

      grid =
        Grid.new(5, 5)
        |> Sidewinder.on()
        |> Distances.calculate({0, 0})

      assert_value inspect(grid) == """
                   +---+---+---+---+---+
                   | 6   5   6   7   8 |
                   +---+   +---+   +---+
                   | 3   4   5 | 8   9 |
                   +   +---+   +---+   +
                   | 2 | 7   6   7 | 10|
                   +   +---+---+---+   +
                   | 1 | 14  13  12  11|
                   +   +   +   +---+   +
                   | 0 | 15| 14  15| 12|
                   +---+---+---+---+---+
                   """
    end
  end
end
