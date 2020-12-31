# credo:disable-for-this-file Credo.Check.Readability.SinglePipe
# credo:disable-for-this-file Credo.Check.Refactor.PipeChainStart

defmodule Mazes.GridTest do
  use ExUnit.Case, async: true
  import AssertValue

  alias Mazes.Algorithms.Sidewinder
  alias Mazes.Grid
  alias Mazes.Solver.Distances

  doctest Grid

  describe "Mazes.Grid.new/2" do
    test "stores the number of rows and columns" do
      grid = Grid.new(2, 3)
      assert {grid.rows, grid.columns} == {2, 3}
    end

    test "creates cells" do
      grid = Grid.new(2, 3)

      assert grid.cells == [
               {0, 0},
               {0, 1},
               {0, 2},
               {1, 0},
               {1, 1},
               {1, 2}
             ]
    end
  end

  describe "Mazes.Grid.north/2" do
    test "returns the cell one row above" do
      grid = Grid.new(3, 3)
      assert Grid.north(grid, {1, 1}) == {2, 1}
    end

    test "returns nil if the cell is on the north border" do
      grid = Grid.new(3, 3)
      assert Grid.north(grid, {2, 1}) == nil
    end
  end

  describe "Mazes.Grid.east/2" do
    test "returns the cell one column to the right" do
      grid = Grid.new(3, 3)
      assert Grid.east(grid, {1, 1}) == {1, 2}
    end

    test "returns nil if the cell is on the east border" do
      grid = Grid.new(3, 3)
      assert Grid.east(grid, {1, 2}) == nil
    end
  end

  describe "Mazes.Grid.south/2" do
    test "returns the cell one row below" do
      grid = Grid.new(3, 3)
      assert Grid.south(grid, {1, 1}) == {0, 1}
    end

    test "returns nil if the cell is on the south border" do
      grid = Grid.new(3, 3)
      assert Grid.south(grid, {0, 1}) == nil
    end
  end

  describe "Mazes.Grid.west/2" do
    test "returns the cell one column to the left" do
      grid = Grid.new(3, 3)
      assert Grid.west(grid, {1, 1}) == {1, 0}
    end

    test "returns nil if the cell is on the west border" do
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

  describe "Mazes.Grid.links/2" do
    test "returns the linked cells" do
      grid = Grid.new(3, 3) |> Grid.link_east({1, 1}) |> Grid.link_north({1, 1})
      assert Grid.links(grid, {1, 1}) == [{2, 1}, {1, 2}]
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

      assert_value inspect(grid) == """
                   +---+---+---+
                   |           |
                   +---+   +   +
                   |       |   |
                   +   +---+   +
                   |   |       |
                   +---+---+---+
                   """
    end

    test "displays distances if pressent" do
      :rand.seed(:exrop, {101, 102, 103})

      grid =
        Grid.new(20, 20)
        |> Sidewinder.on()
        |> Distances.calculate({0, 0})

      assert_value inspect(grid) == """
                   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
                   | 49  48  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64|
                   +   +   +   +---+---+   +   +---+   +   +   +   +---+---+   +---+---+   +---+   +
                   | 50| 49| 46  47| 52  51| 52| 55  54| 55| 56| 57| 62  61  60| 65  64  63  64| 65|
                   +   +---+   +---+---+---+   +---+---+---+   +---+   +---+   +   +   +---+   +---+
                   | 51  52| 45  46  47| 54  53  54  55| 58  57| 64  63| 62  61| 66| 65| 66  65  66|
                   +---+---+   +   +---+   +   +   +---+   +---+---+   +---+   +   +   +   +---+   +
                   | 42  43  44| 47  48| 55| 54| 55  56| 59| 66  65  64  65| 62| 67| 66| 67  68| 67|
                   +   +---+   +---+   +---+   +   +---+---+   +---+   +---+   +---+---+---+   +---+
                   | 41| 46  45  46| 49| 56  55| 56  57  58| 67| 66  65| 64  63| 72  71  70  69  70|
                   +   +---+---+---+---+---+   +   +---+---+---+   +---+---+---+---+   +---+   +   +
                   | 40  39  38  37  36  35| 56| 57  58  59| 68  67  68  69  70  71| 72| 71  70| 71|
                   +---+---+---+---+---+   +   +   +---+   +---+---+---+---+---+   +---+   +   +---+
                   | 29  30  31  32  33  34| 57| 58| 61  60  61  62  63  64  65| 72| 73  72| 71  72|
                   +   +---+---+---+---+   +---+---+---+---+---+---+   +   +---+   +---+---+   +   +
                   | 28  27  26  25| 36  35  36  37| 68  67  66  65  64| 65| 74  73  74| 73  72| 73|
                   +   +   +---+   +---+   +---+   +   +---+   +---+   +---+---+---+   +---+   +   +
                   | 29| 28| 23  24| 37  36  37| 38| 69  70| 67| 66  65  66| 77  76  75| 74  73| 74|
                   +   +   +   +---+   +---+---+---+---+   +---+---+---+---+   +---+   +   +   +---+
                   | 30| 29| 22  21| 38| 75  74  73  72  71| 82  81  80  79  78  79| 76| 75| 74  75|
                   +   +   +---+   +---+---+---+---+   +   +---+---+   +---+---+   +   +   +   +   +
                   | 31| 30| 21  20  19  18  17| 74  73| 72  73  74| 81  82  83| 80| 77| 76| 75| 76|
                   +   +   +---+   +   +   +   +---+   +---+---+---+   +   +---+   +   +---+---+   +
                   | 32| 31| 22  21| 20| 19| 16  17| 74| 85  84  83  82| 83| 82  81| 78| 79  78  77|
                   +---+   +---+   +   +   +   +   +---+   +---+---+---+   +   +   +---+   +   +   +
                   | 33  32| 23  22| 21| 20| 15| 18| 87  86  87  88| 85  84| 83| 82| 81  80| 79| 78|
                   +   +   +   +   +---+---+   +   +   +   +   +   +   +   +   +---+---+   +   +   +
                   | 34| 33| 24| 23| 12  13  14| 19| 88| 87| 88| 89| 86| 85| 84  85  86| 81| 80| 79|
                   +   +---+   +---+   +---+   +   +   +   +---+   +---+---+   +   +---+   +   +   +
                   | 35| 26  25| 12  11  10| 15| 20| 89| 88  89| 90  91| 86  85| 86| 83  82| 81| 80|
                   +   +   +---+   +---+   +---+---+---+---+   +---+---+   +---+   +   +---+   +   +
                   | 36| 27  28| 13| 10  9   10| 93  92  91  90  91  92| 87  88| 87| 84  85| 82| 81|
                   +---+---+---+   +   +   +---+   +   +---+   +---+   +   +   +   +   +   +   +   +
                   | 17  16  15  14| 11| 8 | 95  94| 93| 92  91| 94  93| 88| 89| 88| 85| 86| 83| 82|
                   +---+---+---+---+---+   +---+   +---+---+---+   +   +---+   +   +---+   +---+   +
                   | 2   3   4   5   6   7 | 96  95| 98  97  96  95| 94| 91  90| 89| 88  87  88| 83|
                   +   +---+---+---+   +---+---+---+---+   +   +---+---+   +---+   +   +---+   +---+
                   | 1 | 10  9   8   7   8   9 |100  99  98| 97| 94  93  92  93| 90| 89  90| 89  90|
                   +   +   +   +---+   +---+---+---+   +---+   +---+---+   +---+---+   +---+   +---+
                   | 0 | 11| 10  11| 8 |103 102 101 100| 99  98  99| 94  93  94| 91  90  91| 90  91|
                   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
                   """
    end
  end
end
