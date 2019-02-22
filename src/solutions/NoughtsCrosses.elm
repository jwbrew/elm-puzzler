module Solutions.NoughtsCrosses exposing (solution)

import Puzzler exposing (Solution)
import Puzzles.NoughtsCrosses exposing (Action(..), Event(..), State)


type alias Go =
    { us : Bool, coords : ( Int, Int ) }


type alias Memory =
    List Go


takeGo : Memory -> Event -> ( Memory, Maybe Action )
takeGo memory (OpponentMove x y) =
    let
        options =
            [ ( 0, 0 )
            , ( 0, 1 )
            , ( 0, 2 )
            , ( 1, 0 )
            , ( 1, 1 )
            , ( 1, 2 )
            , ( 2, 0 )
            , ( 2, 1 )
            , ( 2, 2 )
            ]

        memory_ =
            { us = False, coords = ( x, y ) } :: memory

        taken =
            List.map .coords memory_

        maybeNext =
            List.filter (\c -> List.member c taken |> not) options
                |> List.head
    in
    case maybeNext of
        Just ( x_, y_ ) ->
            ( { us = True, coords = ( x_, y_ ) } :: memory_, PlayerMove x_ y_ |> Just )

        Nothing ->
            ( memory_, Nothing )


solution : Solution Memory Event Action
solution =
    { init = []
    , handleEvent = takeGo
    }
