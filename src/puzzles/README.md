# Puzzles

## NoughtsCrosses

A simple noughts & crosses simulation.

```elm
type Action
    = TakeMove Int Int
```
A single action that lets the Solution play a move


```elm
type Event
    = MoveTaken Int Int
```
A single Event to notify the solution that the opponent has moved
