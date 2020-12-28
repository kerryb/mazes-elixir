defmodule Mazes.Grid do
  @moduledoc """
  A struct representing a maze grid, with functions to operate on it.

  Fields:

    * rows: the number of rows in the grid
    * columns: the number of columns in the grid
    * cells: a list of `{row, column}` tuples representing the cells in the
      grid
    * links: a map of cell coords to lists of their linked cells
  """

  @enforce_keys [:rows, :columns]
  defstruct rows: nil, columns: nil, cells: [], links: %{}

  def new(rows, columns) do
    cells =
      for row <- 0..(rows - 1), column <- 0..columns do
        {row, column}
      end

    %__MODULE__{rows: rows, columns: columns, cells: cells}
  end

  def north(%{rows: rows}, {row, _}) when row >= rows - 1, do: nil
  def north(_, {row, column}), do: {row + 1, column}

  def east(%{columns: columns}, {_, column}) when column >= columns - 1, do: nil
  def east(_, {row, column}), do: {row, column + 1}

  def south(_, {row, _}) when row <= 0, do: nil
  def south(_, {row, column}), do: {row - 1, column}

  def west(_, {_, column}) when column <= 0, do: nil
  def west(_, {row, column}), do: {row, column - 1}

  def link_north(grid, coords), do: link(grid, coords, north(grid, coords))
  def link_east(grid, coords), do: link(grid, coords, east(grid, coords))
  def link_south(grid, coords), do: link(grid, coords, south(grid, coords))
  def link_west(grid, coords), do: link(grid, coords, west(grid, coords))

  defp link(grid, from, to) do
    links =
      grid.links
      |> Map.update(from, [to], &[to | &1])
      |> Map.update(to, [from], &[from | &1])

    %{grid | links: links}
  end

  def linked_north?(grid, cell), do: north(grid, cell) in links(grid, cell)
  def linked_east?(grid, cell), do: east(grid, cell) in links(grid, cell)
  def linked_south?(grid, cell), do: south(grid, cell) in links(grid, cell)
  def linked_west?(grid, cell), do: west(grid, cell) in links(grid, cell)

  defp links(grid, cell) do
    case grid.links[cell] do
      nil -> []
      links -> links
    end
  end

  def map_cells(grid, fun) do
    for row <- 0..(grid.rows - 1), column <- 0..(grid.columns - 1) do
      {row, column}
    end
    |> Enum.reduce(grid, &fun.(&2, &1))
  end

  def map_rows(grid, fun) do
    for row <- 0..(grid.rows - 1) do
      for column <- 0..(grid.columns - 1) do
        {row, column}
      end
    end
    |> Enum.reduce(grid, &fun.(&2, &1))
  end

  defimpl Inspect do
    alias Mazes.Grid

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

    defp inspect_cell_top(grid, coords) do
      if Grid.linked_east?(grid, coords), do: "    ", else: "   |"
    end

    defp inspect_cell_bottom(grid, coords) do
      if Grid.linked_south?(grid, coords), do: "   +", else: "---+"
    end
  end
end
