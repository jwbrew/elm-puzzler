# Elm Puzzler
A framework for creating puzzles & solutions written in Elm, to help newcomers
learn the language and then move on to building their own puzzles.

N.B. This is *very* much a work in progress. Inspired at and by 
[Elm London](https://www.meetup.com/Elm-London-Meetup/)
and intended as an educational tool. Contributions immensely welcome.

### A Puzzle

Puzzler exports the `Puzzle` type, which provides a standardised interface for
designing puzzles:

```elm
type alias Puzzle state event action =
    { init : state
    , view : state -> Html ()
    , handleTick : state -> Tick -> ( state, Maybe event )
    , handleAction : state -> action -> ( state, Maybe event )
    }
```

The `state` defines the internal puzzle state at any given moment

An `event` is passed from the Puzzle to the Solution, which the Solution may
choose to respond to with an

`action`, which is a Puzzle-defined response to an Event that a Solution may
offer


The `view` function converts the current state into a view for the user.
The `handleTick` function allows the puzzle to update the game state and emit
events asynchronously
The `handleAction` function provides a synchroinous response to a Solution's
Action


### A Solution
```elm
type alias Solution memory event action =
    { init : memory
    , handleEvent : memory -> event -> ( memory, Maybe action )
    }
```

A solution has an internal `memory` that can be used for tracing moves etc. It's
initialised with the `init` function.

The main game logic then is encapsulated in a `handleEvent` function, which
receives the current `memory`, a new puzzle `event`, and returns a new `memory`
with an optional `action`, if required.

## Getting Started

[Install Elm](https://guide.elm-lang.org/install.html)

`git clone jwbrew/elm-puzzler`

cd elm-puzzler

### Running A Puzzle
```elm
run :
    Puzzle state event action
    -> Solution memory event action
    -> Program Flags (Model memory state) (Msg action)
```
`Puzzler` exports `run`, which returns a `Program`. Running the puzzle & solution
is as simple as `Puzzler.run puzzle solution`.

Recommendation: use `elm-live` with `-debug` on to enable the time-travelling
debugger when developing solutions.

`npm i -g elm-live`

`elm-live Main.elm -- --debug`

## Puzzles

### NoughtsCrosses
Bundled intially there's a naieve implmentation of noughts and crosses. Your
opponent is 0, you are X. Your opponent moves first, but has a pretty rubbish
strategy.

The demo solution always loses. Try to find a way to make it win.
