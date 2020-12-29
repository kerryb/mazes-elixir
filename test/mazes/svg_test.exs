# credo:disable-for-this-file Credo.Check.Refactor.PipeChainStart

defmodule Mazes.SVGTest do
  use ExUnit.Case, async: true
  import AssertValue

  alias Mazes.Algorithms.Sidewinder
  alias Mazes.{Grid, SVG}

  doctest SVG

  describe "Mazes.SVG.render/2" do
    test "renders the grid as an SVG to the supplied file path" do
      path = Briefly.create!(directory: true)
      file = Path.join(path, "test.svg")
      :rand.seed(:exrop, {101, 102, 103})
      Grid.new(5, 5) |> Sidewinder.on() |> SVG.render(file)
      # Uncomment the following line to open the SVG in the default app (on
      # macOS, at least) for visual checking before accepting/rejecting a new
      # value
      # System.cmd("open", [file])
      assert_value File.read!(file) == """
                   <?xml version=\"1.0\" standalone=\"no\"?>
                   <svg width=\"60\" height=\"60\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">
                     <rect x=\"5\" y=\"5\" width=\"50\"
                         height=\"50\" stroke=\"black\" fill=\"transparent\" stroke-width=\"2\" />
                         <line x1=\"15\" y1=\"45\" x2=\"15\" y2=\"55\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"5\" y1=\"55\" x2=\"15\" y2=\"55\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"5\" y1=\"45\" x2=\"5\" y2=\"55\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"25\" y1=\"45\" x2=\"25\" y2=\"55\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"15\" y1=\"55\" x2=\"25\" y2=\"55\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"15\" y1=\"45\" x2=\"15\" y2=\"55\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"25\" y1=\"55\" x2=\"35\" y2=\"55\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"25\" y1=\"45\" x2=\"25\" y2=\"55\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"35\" y1=\"45\" x2=\"45\" y2=\"45\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"45\" y1=\"45\" x2=\"45\" y2=\"55\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"35\" y1=\"55\" x2=\"45\" y2=\"55\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"55\" y1=\"45\" x2=\"55\" y2=\"55\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"45\" y1=\"55\" x2=\"55\" y2=\"55\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"45\" y1=\"45\" x2=\"45\" y2=\"55\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"15\" y1=\"35\" x2=\"15\" y2=\"45\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"5\" y1=\"35\" x2=\"5\" y2=\"45\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"15\" y1=\"35\" x2=\"25\" y2=\"35\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"15\" y1=\"35\" x2=\"15\" y2=\"45\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"25\" y1=\"35\" x2=\"35\" y2=\"35\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"35\" y1=\"35\" x2=\"45\" y2=\"35\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"35\" y1=\"45\" x2=\"45\" y2=\"45\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"55\" y1=\"35\" x2=\"55\" y2=\"45\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"15\" y1=\"25\" x2=\"15\" y2=\"35\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"5\" y1=\"25\" x2=\"5\" y2=\"35\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"15\" y1=\"25\" x2=\"25\" y2=\"25\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"15\" y1=\"35\" x2=\"25\" y2=\"35\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"15\" y1=\"25\" x2=\"15\" y2=\"35\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"25\" y1=\"35\" x2=\"35\" y2=\"35\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"35\" y1=\"25\" x2=\"45\" y2=\"25\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"45\" y1=\"25\" x2=\"45\" y2=\"35\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"35\" y1=\"35\" x2=\"45\" y2=\"35\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"55\" y1=\"25\" x2=\"55\" y2=\"35\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"45\" y1=\"25\" x2=\"45\" y2=\"35\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"5\" y1=\"15\" x2=\"15\" y2=\"15\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"5\" y1=\"15\" x2=\"5\" y2=\"25\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"15\" y1=\"25\" x2=\"25\" y2=\"25\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"25\" y1=\"15\" x2=\"35\" y2=\"15\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"35\" y1=\"15\" x2=\"35\" y2=\"25\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"35\" y1=\"25\" x2=\"45\" y2=\"25\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"35\" y1=\"15\" x2=\"35\" y2=\"25\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"45\" y1=\"15\" x2=\"55\" y2=\"15\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"55\" y1=\"15\" x2=\"55\" y2=\"25\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"5\" y1=\"5\" x2=\"15\" y2=\"5\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"5\" y1=\"15\" x2=\"15\" y2=\"15\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"5\" y1=\"5\" x2=\"5\" y2=\"15\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"15\" y1=\"5\" x2=\"25\" y2=\"5\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"25\" y1=\"5\" x2=\"35\" y2=\"5\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"25\" y1=\"15\" x2=\"35\" y2=\"15\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"35\" y1=\"5\" x2=\"45\" y2=\"5\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"45\" y1=\"5\" x2=\"55\" y2=\"5\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"55\" y1=\"5\" x2=\"55\" y2=\"15\" stroke=\"black\" stroke-width=\"1\" />
                         <line x1=\"45\" y1=\"15\" x2=\"55\" y2=\"15\" stroke=\"black\" stroke-width=\"1\" />
                   </svg>
                   """
    end
  end
end
