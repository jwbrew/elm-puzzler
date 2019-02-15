module Puzzles.NoughtsCrosses exposing (Action(..), Event(..), State, puzzle)

import Html exposing (Html)
import Puzzle exposing (Puzzle, Tick)


type Action
    = TakeMove Int Int


type Event
    = MoveTaken


type Piece
    = Nought
    | Cross


type alias Go =
    { x : Int
    , y : Int
    , piece : Piece
    }


type alias State =
    { gos : List Go, self : Piece, start : Piece }



-- We don't do anything here, just respond to user moves


handleTick : State -> Tick -> ( State, Maybe Event )
handleTick state tick =
    if tick == 2 && List.isEmpty state.gos then
        ( takeMove state, Just MoveTaken )

    else
        ( state, Nothing )



-- It'd be easier here to return a Maybe Event to pass stright back to the
-- solution code, instead of wait for handleTick to see if we've taken our
-- turn


handleAction : State -> Action -> ( State, Maybe Event )
handleAction state (TakeMove x y) =
    if List.length state.gos == 9 then
        ( state, Nothing )

    else
        ( { state | gos = Go x y Cross :: state.gos }
            |> takeMove
        , Just MoveTaken
        )


takeMove : State -> State
takeMove state =
    { state | gos = Go 1 2 Nought :: state.gos }


view : State -> Html ()
view state =
    Html.pre []
        [ Debug.toString state
            |> Html.text
        ]


puzzle : Puzzle State Event Action
puzzle =
    { init = { gos = [], self = Nought, start = Nought }
    , view = view
    , handleTick = handleTick
    , handleAction = handleAction
    }
