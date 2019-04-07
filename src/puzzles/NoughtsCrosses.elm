module Puzzles.NoughtsCrosses exposing (Action(..), Event(..), State, puzzle)

import Html exposing (Html)
import Puzzler exposing (Puzzle, Tick)


type Action
    = PlayerMove Int Int


type Event
    = OpponentMove Int Int


type alias Go =
    { us : Bool, coords : ( Int, Int ) }


type alias State =
    List Go


handleTick : State -> Tick -> ( State, Maybe Event )
handleTick state tick =
    case ( tick, state ) of
        ( 1, [] ) ->
            takeGo state

        ( _, { us, coords } :: _ ) ->
            if us then
                ( state, Just <| OpponentMove (Tuple.first coords) (Tuple.second coords) )

            else
                takeGo state

        _ ->
            ( state, Nothing )


handleAction : State -> Action -> ( State, Maybe Event )
handleAction state (PlayerMove x y) =
    if List.length state == 9 then
        ( state, Nothing )

    else
        ( { us = False, coords = ( x, y ) }
            :: state
        , Nothing
        )


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
            ( { us = True, coords = ( x, y ) } :: state, Nothing )

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
