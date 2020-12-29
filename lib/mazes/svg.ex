defmodule Mazes.SVG do
  @moduledoc """
  SVG renderer for `Mazes.Grid` structs.
  """

  alias Mazes.Grid

  require EEx

  @spec render(Grid.t(), String.t()) :: :ok | {:error, atom()}
  def render(grid, path) do
    File.write(path, grid |> svg() |> String.replace(~r/^[ \t]*$\n/m, ""))
  end

  @template """
  <?xml version="1.0" standalone="no"?>
  <% cell_size = 10 %>
  <% margin = 5 %>
  <% width = grid.columns * cell_size + margin * 2 %>
  <% height = grid.rows * cell_size + margin * 2 %>
  <svg width="<%= width %>" height="<%= height %>" version="1.1" xmlns="http://www.w3.org/2000/svg">
    <rect x="<%= margin %>" y="<%= margin %>" width="<%= grid.columns * cell_size %>"
        height="<%= grid.rows * cell_size %>" stroke="black" fill="transparent" stroke-width="2" />
    <%= for {row, column} = cell <- grid.cells do %>
      <% west = column * cell_size + margin %>
      <% east = (column + 1) * cell_size + margin %>
      <% south = (grid.rows - row) * cell_size + margin %>
      <% north = (grid.rows - row - 1) * cell_size + margin %>
      <%= unless Grid.linked_north?(grid, cell) do %>
        <line x1="<%= west %>" y1="<%= north %>" x2="<%= east %>" y2="<%= north %>" stroke="black" stroke-width="1" />
      <% end %>
      <%= unless Grid.linked_east?(grid, cell) do %>
        <line x1="<%= east %>" y1="<%= north %>" x2="<%= east %>" y2="<%= south %>" stroke="black" stroke-width="1" />
      <% end %>
      <%= unless Grid.linked_south?(grid, cell) do %>
        <line x1="<%= west %>" y1="<%= south %>" x2="<%= east %>" y2="<%= south %>" stroke="black" stroke-width="1" />
      <% end %>
      <%= unless Grid.linked_west?(grid, cell) do %>
        <line x1="<%= west %>" y1="<%= north %>" x2="<%= west %>" y2="<%= south %>" stroke="black" stroke-width="1" />
      <% end %>
    <% end %>
  </svg>
  """
  EEx.function_from_string(:defp, :svg, @template, [:grid])
end
