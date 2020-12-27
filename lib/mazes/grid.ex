defmodule Mazes.Grid do
  alias Mazes.Cell

  @enforce_keys [:rows, :columns, :cells, :links]
  defstruct rows: nil, columns: nil, cells: nil

  @type t :: %__MODULE__{rows: integer(), columns: integer(), cells: %{Cell.coords() => Cell.t()}}

  @spec new(integer(), integer()) :: t()
  def new(rows, columns) do
    %__MODULE__{rows: rows, columns: columns, cells: build_grid(rows, columns)}
  end

  defimpl Inspect do
    def inspect(grid, _opts) do
      [
        ["+", String.duplicate("---+", grid.columns), "\n"],
        Enum.map((grid.rows - 1)..0, &inspect_row(grid, &1))
      ]
      |> IO.chardata_to_string()
    end

    defp inspect_row(grid, row) do
      [
        "|",
        inspect_cells(grid, row, &inspect_cell_top/2),
        "\n+",
        inspect_cells(grid, row, &inspect_cell_bottom/2),
        "\n"
      ]
    end

    defp inspect_cells(grid, row, fun) do
      Enum.map(0..(grid.columns - 1), &fun.(grid, {row, &1}))
    end

    defp inspect_cell_top(grid, {row, column} = coords) do
      if Cell.linked?(grid.cells[coords], {row, column + 1}), do: "    ", else: "   |"
    end

    defp inspect_cell_bottom(grid, {row, column} = coords) do
      if Cell.linked?(grid.cells[coords], {row - 1, column}), do: "   +", else: "---+"
    end
  end

  defp build_grid(rows, columns) do
    prepare_grid(rows, columns)
    |> configure_cells()
  end

  defp prepare_grid(rows, columns) do
    for row <- 0..(rows - 1), column <- 0..(columns - 1) do
      {{row, column}, Cell.new({row, column})}
    end
    |> Enum.into(%{})
  end

  defp configure_cells(cells), do: Enum.into(cells, %{}, &add_neighbours(&1, cells))

  defp add_neighbours({{row, column}, cell}, cells) do
    {{row, column},
     Cell.add_neighbours(
       cell,
       coords_if_cell_exists(cells, {row + 1, column}),
       coords_if_cell_exists(cells, {row, column + 1}),
       coords_if_cell_exists(cells, {row - 1, column}),
       coords_if_cell_exists(cells, {row, column - 1})
     )}
  end

  defp coords_if_cell_exists(cells, coords) do
    case cells[coords] do
      nil -> nil
      cell -> cell.coords
    end
  end

  @spec random_coords(t()) :: Cell.coords()
  def random_coords(grid) do
    {:rand.uniform(grid.rows) - 1, :rand.uniform(grid.columns) - 1}
  end

  @spec size(t()) :: integer()
  def size(grid), do: grid.rows * grid.columns

  @spec map_rows(t(), ([Cell.t()] -> [Cell.t()])) :: t()
  def map_rows(grid, fun) do
    grid.cells
    |> Enum.group_by(fn {{row, _column}, _cell} -> row end, fn {_coords, cell} -> cell end)
    |> Map.values()
    |> Enum.flat_map(fun)
    |> reduce_cells(grid, fun)
  end

  @spec map_cells(t(), (Cell.t() -> Cell.t())) :: t()
  def map_cells(grid, fun) do
    grid.cells
    |> Map.values()
    |> reduce_cells(grid, fun)
  end

  defp reduce_cells(cells, grid, fun) do
    Enum.reduce(cells, grid, fn cell, grid ->
      put_in(grid.cells[cell.coords], fun.(cell))
    end)
  end
end
