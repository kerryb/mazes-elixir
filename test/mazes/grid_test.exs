defmodule Mazes.GridTest do
  use ExUnit.Case, async: true

  alias Mazes.Grid

  doctest Grid

  describe "Mazes.Grid.new/2" do
    test "stores the number of rows and columns" do
      grid = Grid.new(2, 3)
      assert {grid.rows, grid.columns} == {2, 3}
    end
  end

  describe "Mazes.Grid.north/2" do
    test "returns the coords of the cell one row above" do
      grid = Grid.new(3, 3)
      assert Grid.north(grid, {1, 1}) == {2, 1}
    end

    test "returns nil if the coords are on the north border" do
      grid = Grid.new(3, 3)
      assert Grid.north(grid, {2, 1}) == nil
    end
  end

  describe "Mazes.Grid.east/2" do
    test "returns the coords of the cell one column to the right" do
      grid = Grid.new(3, 3)
      assert Grid.east(grid, {1, 1}) == {1, 2}
    end

    test "returns nil if the coords are on the east border" do
      grid = Grid.new(3, 3)
      assert Grid.east(grid, {1, 2}) == nil
    end
  end

  describe "Mazes.Grid.south/2" do
    test "returns the coords of the cell one row below" do
      grid = Grid.new(3, 3)
      assert Grid.south(grid, {1, 1}) == {0, 1}
    end

    test "returns nil if the coords are on the south border" do
      grid = Grid.new(3, 3)
      assert Grid.south(grid, {0, 1}) == nil
    end
  end

  describe "Mazes.Grid.west/2" do
    test "returns the coords of the cell one column to the left" do
      grid = Grid.new(3, 3)
      assert Grid.west(grid, {1, 1}) == {1, 0}
    end

    test "returns nil if the coords are on the west border" do
      grid = Grid.new(3, 3)
      assert Grid.west(grid, {2, 0}) == nil
    end
  end

  describe "Mazes.Grid.link_north/2" do
    test "adds bidirectional links with the cell with the cell's northern neighbour" do
      grid = Grid.new(3, 3) |> Grid.link_north({1, 1}) |> Grid.link_north({0, 1})
      assert grid.links == %{{1, 1} => [{0, 1}, {2, 1}], {2, 1} => [{1, 1}], {0, 1} => [{1, 1}]}
    end
  end

  describe "Mazes.Grid.link_east/2" do
    test "adds bidirectional links with the cell with the cell's eastern neighbour" do
      grid = Grid.new(3, 3) |> Grid.link_east({1, 1})
      assert grid.links == %{{1, 1} => [{1, 2}], {1, 2} => [{1, 1}]}
    end
  end

  describe "Mazes.Grid.link_south/2" do
    test "adds bidirectional links with the cell with the cell's southern neighbour" do
      grid = Grid.new(3, 3) |> Grid.link_south({1, 1})
      assert grid.links == %{{1, 1} => [{0, 1}], {0, 1} => [{1, 1}]}
    end
  end

  describe "Mazes.Grid.link_west/2" do
    test "adds bidirectional links with the cell with the cell's western neighbour" do
      grid = Grid.new(3, 3) |> Grid.link_west({1, 1})
      assert grid.links == %{{1, 1} => [{1, 0}], {1, 0} => [{1, 1}]}
    end
  end

  describe "Mazes.Grid.linked_north?/2" do
    test "is true if the cell links to its northern neighbour" do
      grid = Grid.new(3, 3) |> Grid.link_north({1, 1})
      assert Grid.linked_north?(grid, {1, 1})
    end

    test "is false if the cell does not link to its northern neighbour" do
      grid = Grid.new(3, 3)
      refute Grid.linked_north?(grid, {1, 1})
    end
  end

  describe "Mazes.Grid.linked_east/2" do
    test "is true if the cell links to its eastern neighbour" do
      grid = Grid.new(3, 3) |> Grid.link_east({1, 1})
      assert Grid.linked_east?(grid, {1, 1})
    end

    test "is false if the cell does not link to its eastern neighbour" do
      grid = Grid.new(3, 3)
      refute Grid.linked_east?(grid, {1, 1})
    end
  end

  describe "Mazes.Grid.linked_south/2" do
    test "is true if the cell links to its southern neighbour" do
      grid = Grid.new(3, 3) |> Grid.link_south({1, 1})
      assert Grid.linked_south?(grid, {1, 1})
    end

    test "is false if the cell does not link to its southern neighbour" do
      grid = Grid.new(3, 3)
      refute Grid.linked_south?(grid, {1, 1})
    end
  end

  describe "Mazes.Grid.linked_west/2" do
    test "is true if the cell links to its western neighbour" do
      grid = Grid.new(3, 3) |> Grid.link_west({1, 1})
      assert Grid.linked_west?(grid, {1, 1})
    end

    test "is false if the cell does not link to its western neighbour" do
      grid = Grid.new(3, 3)
      refute Grid.linked_west?(grid, {1, 1})
    end
  end

  describe "Mazes.Grid.map_cells/2" do
    test "maps over all cells with the supplied function" do
      grid = Grid.new(3, 3) |> Grid.map_cells(&Grid.link_north/2)

      for row <- 0..2, column <- 0..2 do
        assert Grid.linked_north?(grid, {row, column})
      end
    end
  end

  describe "Mazes.Grid.map_rows/2" do
    test "maps over all rows with the supplied function" do
      grid =
        Grid.new(3, 3)
        |> Grid.map_rows(fn grid, [a, _, c] ->
          grid
          |> Grid.link_north(a)
          |> Grid.link_east(c)
        end)

      for row <- 0..2 do
        assert Grid.linked_north?(grid, {row, 0})
        assert Grid.linked_east?(grid, {row, 2})
      end
    end
  end

  describe "Inspect implementation for Mazes.Grid" do
    test "returns an ASCII art representation of the grid" do
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

      assert inspect(grid) == """
             +---+---+---+
             |           |
             +---+   +   +
             |       |   |
             +   +---+   +
             |   |       |
             +---+---+---+
             """
    end
  end
end
