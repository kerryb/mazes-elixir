# Mazes

Working through Jamis Buck’s
[Mazes for
Programmers](https://pragprog.com/titles/jbmaze/mazes-for-programmers/) book in
Elixir.

## Running tests and stuff

    make

## Building mazes manually

For example:

    $ iex -S mix
    iex(1)> # Output as Ascii art to the terminal
    iex(2)> Mazes.Grid.new(20, 20) |> Mazes.Algorithms.BinaryTree.on()

    iex(3)> # Render to a file as SVG
    iex(4)> Mazes.Grid.new(50, 100) |> Mazes.Algorithms.Sidewinder.on() |> Mazes.SVG.render("maze.svg")
