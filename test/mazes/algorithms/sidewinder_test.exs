# credo:disable-for-this-file Credo.Check.Readability.SinglePipe
# credo:disable-for-this-file Credo.Check.Refactor.PipeChainStart

defmodule Mazes.Algorithms.SidewinderTest do
  use ExUnit.Case, async: true

  alias Mazes.Algorithms.Sidewinder
  alias Mazes.Grid

  doctest Sidewinder

  describe "Mazes.Sidewinder.on/1" do
    test "links all cells on the northern border" do
      grid = Grid.new(3, 3) |> Sidewinder.on()
      assert Grid.linked_east?(grid, {2, 0})
      assert Grid.linked_east?(grid, {2, 1})
    end

    test "creates one northward link from each horizontal run of cells on other rows" do
      grid = Grid.new(4, 4) |> Sidewinder.on()

      for row <- 0..2, column <- 0..3 do
        {row, column}
      end
      |> Enum.chunk_while(
        [],
        fn cell, run ->
          if Grid.linked_east?(grid, cell),
            do: {:cont, [cell | run]},
            else: {:cont, Enum.reverse([cell | run]), []}
        end,
        fn run -> {:cont, Enum.reverse(run)} end
      )
      |> Enum.each(fn run ->
        assert Enum.count(run, &Grid.linked_north?(grid, &1)) == 1
      end)
    end
  end
end
