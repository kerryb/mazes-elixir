defmodule Mazes.Algorithms.BinaryTree do
  @moduledoc """
  Implementation of the binary tree algorithm.
  """

  alias Mazes.Grid

  @spec on(Grid.t()) :: Grid.t()
  def on(grid) do
    Grid.map_cells(grid, &link_north_or_east/2)
  end

  def link_north_or_east(grid, cell) do
    case {Grid.north(grid, cell), Grid.east(grid, cell), :rand.uniform(2)} do
      {nil, nil, _} -> grid
      {_, nil, _} -> Grid.link_north(grid, cell)
      {nil, _, _} -> Grid.link_east(grid, cell)
      {_, _, 1} -> Grid.link_north(grid, cell)
      _ -> Grid.link_east(grid, cell)
    end
  end
end
