module Puzzles.NoughtsCrosses exposing (Action(..), Event(..), State, puzzle)

import Html exposing (Html)
import Puzzler exposing (Puzzle, Tick)


type Action
    = TakeMove Int Int


type Event
    = MoveTaken Int Int


type Piece
    = Nought
    | Cross


type alias Go =
    { us : Bool, coords : ( Int, Int ) }


type alias State =
    List Go


handleTick : State -> Tick -> ( State, Maybe Event )
handleTick state tick =
    if tick == 1 && List.isEmpty state then
        takeGo state

    else
        ( state, Nothing )


handleAction : State -> Action -> ( State, Maybe Event )
handleAction state (TakeMove x y) =
    if List.length state == 9 then
        ( state, Nothing )

    else
        { us = False, coords = ( x, y ) }
            :: state
            |> takeGo


takeGo : State -> ( State, Maybe Event )
takeGo state =
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

        taken =
            List.map .coords state

        maybeNext =
            List.filter (\c -> List.member c taken |> not) options
                |> List.head
    in
    case maybeNext of
        Just ( x, y ) ->
            ( { us = True, coords = ( x, y ) } :: state, Just <| MoveTaken x y )

        Nothing ->
            ( state, Nothing )


cell : State -> Int -> Int -> Html ()
cell state x y =
    Html.td []
        [ Html.text <|
            case
                state
                    |> List.filter
                        (\go ->
                            Tuple.first go.coords
                                == x
                                && Tuple.second go.coords
                                == y
                        )
                    |> List.head
            of
                Just go ->
                    if go.us then
                        "0"

                    else
                        "X"

                Nothing ->
                    ""
        ]


view : State -> Html ()
view state =
    Html.table []
        [ Html.tbody []
            [ Html.tr []
                [ cell state 0 0
                , cell state 0 1
                , cell state 0 2
                ]
            , Html.tr []
                [ cell state 1 0
                , cell state 1 1
                , cell state 1 2
                ]
            , Html.tr []
                [ cell state 2 0
                , cell state 2 1
                , cell state 2 2
                ]
            ]
        ]


puzzle : Puzzle State Event Action
puzzle =
    { init = []
    , view = view
    , handleTick = handleTick
    , handleAction = handleAction
    }
