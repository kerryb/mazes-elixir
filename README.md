# Mazes

Working through Jamis Buck’s
[https://pragprog.com/titles/jbmaze/mazes-for-programmers/](Mazes for
programmers) book in Elixir.

## Running tests

    mix test # obviously

## Building mazes manually

For example:

    iex> Mazes.Grid.new(20, 20) |> Mazes.Algorithms.BinaryTree.on()
