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
    case {Grid.north(grid, cell), Grid.east(grid, cell), Enum.random([:north, :east])} do
      {nil = _north_neighbour, nil = _east_neighbour, _preferred} -> grid
      {_north_neighbour, nil = _east_neighbour, _preferred} -> Grid.link_north(grid, cell)
      {nil = _north_neighbour, _east_neighbour, _preferred} -> Grid.link_east(grid, cell)
      {_north_neighbour, _east_neighbour, :north} -> Grid.link_north(grid, cell)
      _default -> Grid.link_east(grid, cell)
    end
  end
end
