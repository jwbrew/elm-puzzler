module Main exposing (main)

import Puzzler
import Puzzles.NoughtsCrosses exposing (puzzle)
import Solutions.NoughtsCrosses exposing (solution)


main =
    Puzzler.run puzzle solution
