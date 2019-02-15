module Puzzle exposing (Puzzle, Solution, Tick, run)

import Browser
import Html exposing (Html)
import Time



{-
   The basic control system for puzzle games.

   It works in a two-part structure - the puzzle and solution. It's designed
   to provide a generic interface such that solutions can be easily swappable
   and new puzzles written.

   The idea is to be able to hide the visibility of the internal state of the
   game, and restrict the possible actions that a player can take. Use of the
   regular Elm architecture would allow the player to arbitrarily change the
   game state to "cheat".

   The puzzle loop consists of a Tick, from which the Puzzle logic optionally
   emits an event. This event is passed to the Solution program, along with
   player-persisted memory, which optionally generates an Action type that is
   defined by the puzzle.

   A game provides
    - a render function to render the current game state to the user
    - an Event type, which passes game events to the solution code
    - an Action type, which allows the solution code to manipulate the puzzle
      state in a controlled way

    - A tick function that calls `processTick` to allow aynchronous state
      updates and events.
-}


type alias Flags =
    ()


type alias Tick =
    Int



-- Event handles the


type Msg action
    = Tick Time.Posix
    | Action action
    | NoOp ()


type alias Model memory state =
    { memory : memory
    , state : state
    , tick : Tick
    }


type alias Puzzle state event action =
    { init : state
    , view : state -> Html ()
    , handleTick : state -> Tick -> ( state, Maybe event )
    , handleAction : state -> action -> ( state, Maybe event )
    }


type alias Solution memory event action =
    { init : memory
    , handleEvent : memory -> event -> ( memory, Maybe action )
    }



-- Takes the new state any maybe Event from the handle* puzzle function, and
-- passes them through the solution code to see if the player has decided to take
-- action. recursive loop called in the case that the player takes action


handler :
    (state -> action -> ( state, Maybe event ))
    -> (memory -> event -> ( memory, Maybe action ))
    -> Model memory state
    -> ( state, Maybe event )
    -> Model memory state
handler handleAction handleEvent model ( state, maybeEvent ) =
    case maybeEvent of
        Nothing ->
            model

        Just event ->
            let
                ( memory, maybeAction ) =
                    handleEvent model.memory event

                model_ =
                    { model | memory = memory, state = state }
            in
            case maybeAction of
                Nothing ->
                    model_

                Just action ->
                    handleAction model_.state action
                        |> handler handleAction handleEvent model_


run :
    Puzzle state event action
    -> Solution memory event action
    -> Program Flags (Model memory state) (Msg action)
run puzzle solution =
    Browser.document
        { init =
            \_ ->
                ( { memory = solution.init
                  , state = puzzle.init
                  , tick = 0
                  }
                , Cmd.none
                )
        , view =
            \model ->
                { title = "Puzzler"
                , body =
                    [ puzzle.view model.state |> Html.map NoOp
                    , Html.pre [] [ Debug.toString model |> Html.text ]
                    ]
                }
        , update =
            \msg model ->
                case msg of
                    Action action ->
                        let
                            model_ =
                                puzzle.handleAction model.state action
                                    |> handler puzzle.handleAction solution.handleEvent model
                        in
                        ( model_, Cmd.none )

                    Tick _ ->
                        let
                            tick_ =
                                model.tick + 1

                            model_ =
                                puzzle.handleTick model.state tick_
                                    |> handler puzzle.handleAction solution.handleEvent model
                        in
                        ( { model_ | tick = tick_ }
                        , Cmd.none
                        )

                    NoOp _ ->
                        ( model, Cmd.none )
        , subscriptions = \_ -> Time.every 1000 Tick
        }
