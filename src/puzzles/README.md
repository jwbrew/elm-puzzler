# Puzzles

## NoughtsCrosses

A simple noughts & crosses simulation. Your opponent is 0, you are X.
Your opponent moves first, but has a pretty rubbish strategy.

```elm
type Action
    = TakeMove Int Int
```
A single action that lets the Solution play a move


```elm
type Event
    = OpponentMove Int Int
```
A single Event to notify the solution that the opponent has moved
