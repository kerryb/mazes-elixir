defmodule Mazes.Solver.Distances do
  @moduledoc """
  Calculates the distance from an origin to each cell, along the shortest path,
  using Dijkstra's algorithm.
  """

  alias Mazes.Grid

  @spec calculate(Grid.t(), Grid.cell()) :: Grid.t()
  def calculate(grid, origin) do
    grid
    |> Map.put(:origin, origin)
    |> calculate_distances([origin], 0)
  end

  defp calculate_distances(grid, [], _distance), do: grid

  defp calculate_distances(grid, frontier, distance) do
    distances =
      frontier
      |> Enum.into(%{}, &{&1, distance})
      |> Map.merge(grid.distances)

    frontier =
      frontier
      |> Enum.flat_map(&Grid.links(grid, &1))
      |> Enum.reject(&Map.has_key?(grid.distances, &1))

    distance = distance + 1
    calculate_distances(%{grid | distances: distances}, frontier, distance)
  end
end
