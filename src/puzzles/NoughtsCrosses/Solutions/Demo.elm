module Puzzles.NoughtsCrosses.Solutions.Demo exposing (solution)

import Puzzle exposing (Solution)
import Puzzles.NoughtsCrosses exposing (Action(..), Event(..), State)


type alias Memory =
    { step : Int
    }


solution : Solution Memory Event Action
solution =
    { init = { step = 0 }
    , handleEvent =
        \memory event ->
            case event of
                MoveTaken ->
                    if memory.step < 9 then
                        ( { memory | step = memory.step + 1 }
                        , TakeMove 0 0 |> Just
                        )

                    else
                        ( memory, Nothing )
    }
