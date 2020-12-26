defmodule Mazes.BinaryTree do
  alias Mazes.{Cell, Grid}

  @spec on(Grid.t()) :: Grid.t()
  def on(grid) do
    Grid.map_cells(grid, &randomly_link_south_or_east/1)
  end

  @spec randomly_link_south_or_east(Cell.t()) :: Cell.t()
  def randomly_link_south_or_east(cell) do
    [cell.south, cell.east]
    |> Enum.reject(&is_nil/1)
    |> case do
      [] -> cell
      neighbours -> Cell.link(cell, Enum.random(neighbours))
    end
  end
end
