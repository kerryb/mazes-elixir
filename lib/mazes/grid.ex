defmodule Mazes.Grid do
  @moduledoc """
  A struct representing a maze grid, with functions to operate on it.

  Fields:

    * rows: the number of rows in the grid
    * columns: the number of columns in the grid
    * cells: a list of `{row, column}` tuples representing the cells in the
      grid
    * links: a map of cells to lists of their linked cells
    * origin: the cell from which distances are calculated (see
      `Mazes.Solver.Distances`)
    * distances: a map of cells to their distances from the origin
  """

  @enforce_keys [:rows, :columns]
  defstruct rows: nil, columns: nil, cells: [], links: %{}, origin: nil, distances: %{}

  @type cell :: {integer(), integer()}
  @type t :: %__MODULE__{
          rows: integer(),
          columns: integer(),
          cells: [cell()],
          links: %{cell() => [cell()]},
          origin: cell() | nil,
          distances: %{cell() => integer()}
        }

  @spec new(integer(), integer()) :: t()
  def new(rows, columns) do
    cells =
      for row <- 0..(rows - 1), column <- 0..(columns - 1) do
        {row, column}
      end

    %__MODULE__{rows: rows, columns: columns, cells: cells}
  end

  @spec north(t(), cell()) :: cell() | nil
  def north(%{rows: rows}, {row, _column}) when row >= rows - 1, do: nil
  def north(_grid, {row, column}), do: {row + 1, column}

  @spec east(t(), cell()) :: cell() | nil
  def east(%{columns: columns}, {_row, column}) when column >= columns - 1, do: nil
  def east(_grid, {row, column}), do: {row, column + 1}

  @spec south(t(), cell()) :: cell() | nil
  def south(_grid, {row, _column}) when row <= 0, do: nil
  def south(_grid, {row, column}), do: {row - 1, column}

  @spec west(t(), cell()) :: cell() | nil
  def west(_grid, {_row, column}) when column <= 0, do: nil
  def west(_grid, {row, column}), do: {row, column - 1}

  @spec link_north(t(), cell()) :: t()
  def link_north(grid, cell), do: link(grid, cell, north(grid, cell))

  @spec link_east(t(), cell()) :: t()
  def link_east(grid, cell), do: link(grid, cell, east(grid, cell))

  @spec link_south(t(), cell()) :: t()
  def link_south(grid, cell), do: link(grid, cell, south(grid, cell))

  @spec link_west(t(), cell()) :: t()
  def link_west(grid, cell), do: link(grid, cell, west(grid, cell))

  defp link(grid, from, to) do
    links =
      grid.links
      |> Map.update(from, [to], &[to | &1])
      |> Map.update(to, [from], &[from | &1])

    %{grid | links: links}
  end

  @spec links(t(), cell()) :: [cell()]
  def links(grid, cell) do
    case grid.links[cell] do
      nil -> []
      links -> links
    end
  end

  @spec linked_north?(t(), cell()) :: boolean()
  def linked_north?(grid, cell), do: north(grid, cell) in links(grid, cell)

  @spec linked_east?(t(), cell()) :: boolean()
  def linked_east?(grid, cell), do: east(grid, cell) in links(grid, cell)

  @spec linked_south?(t(), cell()) :: boolean()
  def linked_south?(grid, cell), do: south(grid, cell) in links(grid, cell)

  @spec linked_west?(t(), cell()) :: boolean()
  def linked_west?(grid, cell), do: west(grid, cell) in links(grid, cell)

  @spec map_cells(t(), (t(), cell() -> t())) :: t()
  def map_cells(grid, fun) do
    Enum.reduce(
      for row <- 0..(grid.rows - 1), column <- 0..(grid.columns - 1) do
        {row, column}
      end,
      grid,
      &fun.(&2, &1)
    )
  end

  @spec map_rows(t(), (t(), [cell()] -> t())) :: t()
  def map_rows(grid, fun) do
    Enum.reduce(
      for row <- 0..(grid.rows - 1) do
        for column <- 0..(grid.columns - 1) do
          {row, column}
        end
      end,
      grid,
      &fun.(&2, &1)
    )
  end

  defimpl Inspect do
    alias Mazes.Grid

    @spec inspect(Grid.t(), Inspect.Opts.t()) :: String.t()
    def inspect(grid, _opts) do
      IO.chardata_to_string([
        ["+", String.duplicate("---+", grid.columns), "\n"],
        Enum.map((grid.rows - 1)..0, &inspect_row(grid, &1))
      ])
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

    defp inspect_cell_top(grid, cell) do
      east_wall = if Grid.linked_east?(grid, cell), do: " ", else: "|"
      "#{format_distance(grid.distances[cell])}#{east_wall}"
    end

    defp format_distance(nil), do: "   "
    defp format_distance(distance) when distance < 10, do: " #{distance} "
    defp format_distance(distance) when distance < 100, do: " #{distance}"
    defp format_distance(distance), do: to_string(distance)

    defp inspect_cell_bottom(grid, cell) do
      if Grid.linked_south?(grid, cell), do: "   +", else: "---+"
    end
  end
end
