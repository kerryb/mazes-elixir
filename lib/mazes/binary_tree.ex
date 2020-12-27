defmodule Mazes.BinaryTree do
  alias Mazes.{Cell, Grid}

  @spec on(Grid.t()) :: Grid.t()
  def on(grid) do
    Grid.map_cells(grid, &randomly_link_north_or_east(&1, grid))
  end

  @spec randomly_link_north_or_east(Cell.t(),Grid.t()) :: Cell.t()
  def randomly_link_north_or_east(cell, grid) do
    [cell.north, cell.east]
    |> Enum.reject(&is_nil/1)
    |> case do
      [] -> cell
      neighbours -> Cell.link(cell, grid.cells[Enum.random(neighbours)])
    end
  end
end
