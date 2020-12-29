defmodule Mazes.Algorithms.BinaryTree do
  @moduledoc """
  Implementation of the binary tree algorithm.
  """

  alias Mazes.Grid

  @spec on(Grid.t()) :: Grid.t()
  def on(grid) do
    Grid.map_cells(grid, &link_north_or_east/2)
  end

  defp link_north_or_east(grid, cell) do
    case {Grid.north(grid, cell), Grid.east(grid, cell), :rand.uniform(2)} do
      {nil, nil, _rand} -> grid
      {_north, nil, _rand} -> Grid.link_north(grid, cell)
      {nil, _east, _rand} -> Grid.link_east(grid, cell)
      {_north, _east, 1} -> Grid.link_north(grid, cell)
      _default -> Grid.link_east(grid, cell)
    end
  end
end
