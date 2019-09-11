module Main exposing (main)

import Puzzler
import Puzzles.Hanoi exposing (puzzle)
import Solutions.HanoiWrongAndSimple exposing (solution)


main =
    Puzzler.run puzzle solution
