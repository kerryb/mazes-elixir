defmodule Mazes.Algorithms.BinaryTree do
  @moduledoc """
  Implementation of the binary tree algorithm.
  """

  alias Mazes.Grid

  @spec on(Grid.t()) :: Grid.t()
  def on(grid) do
    Grid.map_cells(grid, &link_north_or_east/2)
  end

  def link_north_or_east(grid, coords) do
    case {Grid.north(grid, coords), Grid.east(grid, coords), :rand.uniform(2)} do
      {nil, nil, _} -> grid
      {_, nil, _} -> Grid.link_north(grid, coords)
      {nil, _, _} -> Grid.link_east(grid, coords)
      {_, _, 1} -> Grid.link_north(grid, coords)
      _ -> Grid.link_east(grid, coords)
    end
  end
end
