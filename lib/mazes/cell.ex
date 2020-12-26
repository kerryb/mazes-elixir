defmodule Mazes.Cell do
  @enforce_keys [:coords, :links]
  defstruct [:coords, :north, :east, :south, :west, :links]

  @type coords :: {integer(), integer()}
  @type t :: %__MODULE__{
          coords: coords(),
          north: coords() | nil,
          east: coords() | nil,
          south: coords() | nil,
          west: coords() | nil,
          links: [coords()]
        }

  @spec new(coords()) :: t()
  def new(coords), do: %__MODULE__{coords: coords, links: []}

  @spec link(t(), t()) :: t()
  def link(from, to) do
    put_in(from.links, [to | from.links])
  end

  @spec linked?(t(), coords()) :: boolean()
  def linked?(cell, coords), do: coords in cell.links

  @spec neighbours(t()) :: [t()]
  def neighbours(cell) do
    Enum.reject([cell.north, cell.east, cell.south, cell.west], &is_nil/1)
  end

  def add_neighbours(cell, north, east, south, west) do
    %{cell | north: north, east: east, south: south, west: west}
  end
end
