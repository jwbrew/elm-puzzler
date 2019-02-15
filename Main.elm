module Main exposing (main)

import Puzzle
import Puzzles.NoughtsCrosses exposing (puzzle)
import Puzzles.NoughtsCrosses.Solutions.Demo exposing (solution)


main =
    Puzzle.run puzzle solution
