module Solutions.HanoiWrongAndSimple exposing (solution)

import Puzzler exposing (Solution)
import Puzzles.Hanoi exposing (Action(..), Event(..), State)


type alias Memory = ()



makeMove : Memory -> Event -> ( Memory, Maybe Action )
makeMove m a =  
    case a of
        IllegalMove  ->
            (m, Nothing)
        GoodMove state ->
            (m, Just (Move 0 2))
            


solution : Solution Memory Event Action 
solution =
    { init = ()
    , handleEvent = makeMove
    }