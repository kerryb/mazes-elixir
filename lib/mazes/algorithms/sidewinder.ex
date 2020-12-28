defmodule Mazes.Algorithms.Sidewinder do
  @moduledoc """
  Implementation of the sidewinder algorithm.
  """

  alias Mazes.Grid

  def on(grid) do
    Grid.map_rows(grid, &link_horizontal_runs/2)
  end

  defp link_horizontal_runs(grid, cells) do
    {grid, _} = Enum.reduce(cells, {grid, []}, &visit_cell/2)
    grid
  end

  defp visit_cell(cell, {grid, run}) do
    at_eastern_boundary? = is_nil(Grid.east(grid, cell))
    at_northern_boundary? = is_nil(Grid.north(grid, cell))

    should_close_out? =
      at_eastern_boundary? or (not at_northern_boundary? and :rand.uniform(2) == 1)

    if should_close_out? do
      {link_random_cell_north_if_possible(grid, [cell | run]), []}
    else
      {Grid.link_east(grid, cell), [cell | run]}
    end
  end

  defp link_random_cell_north_if_possible(grid, run) do
    cell = Enum.random(run)

    if Grid.north(grid, cell) do
      Grid.link_north(grid, cell)
    else
      grid
    end
  end
end
