defmodule Mazes.Solver.Distances do
  @moduledoc """
  Calculates the distance from an origin to each cell, along the shortest path,
  using Dijkstra's algorithm.
  """

  alias Mazes.Grid

  @spec calculate(Grid.t(), Grid.cell()) :: Grid.t()
  def calculate(grid, origin) do
    grid
    |> struct(origin: origin)
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

  @spec solve(Grid.t(), Grid.cell()) :: Grid.t()
  def solve(grid, goal) do
    grid
    |> struct(goal: goal, solved?: true)
    |> walk_reverse_path([goal])
  end

  defp walk_reverse_path(%{origin: cell} = grid, [cell | _] = path), do: %{grid | solution: path}

  defp walk_reverse_path(grid, [current | _] = path) do
    next = grid |> Grid.links(current) |> Enum.min_by(&grid.distances[&1])
    walk_reverse_path(grid, [next | path])
  end
end
