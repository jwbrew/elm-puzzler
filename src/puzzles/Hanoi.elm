module Puzzles.Hanoi exposing (Action(..), Event(..), State, puzzle)

import Html exposing (Html)
import Puzzler exposing (Puzzle, Tick)
import Html.Attributes exposing (..)
import Array
import List
import Debug 

-- Block specifies the block width 
type alias Block 
    = Int

type alias Tower 
    = (List Block)

type alias TowerState = (Array.Array Tower)

type alias State = Maybe TowerState

type Action 
    = Move Int Int
    | Finish
    

type Event 
    = GoodMove TowerState
    | IllegalMove


type PopResult
    = PopSuccess Block Tower
    | PopFailure

popBlock : Tower -> PopResult
popBlock t = 
    case t of
        x :: xs ->
            PopSuccess x xs        
        [] -> 
            PopFailure

pushBlock : Block -> Tower -> Maybe Tower
pushBlock block tower = 
    case tower of 
        x :: xs ->
            if 
                x < block 
            then 
                Nothing 
            else  
                Just (block :: tower)        
        [] -> Just [block]
        


view : State -> Html ()
view state = 
    case state of
        Just towers ->
            let 
                max = List.foldl findMax [] (Array.toList towers)
            in
            Html.div [] 
                [ Html.div 
                    [ style "display" "flex"
                    , style "flex-direction" "row"            
                    ] 
                    ( List.map renderTower (Array.toList towers) )
                ]
        
        Nothing ->
            Html.div [] [ Html.text "Illegal move detected"]
            
    
renderBlock : Block -> Html()
renderBlock block = 
    Html.div [] [Html.text (Debug.toString block) ]

renderTower : Tower -> Html ()
renderTower tower =
     Html.div 
        [ style "display" "flex"
        , style "flex-direction" "column"
        , style "border" "1px solid black"
        , style "padding" "10px"
        , style "margin" "10px"
        , style "justify-content" "flex-end"
        ] 
        (List.map renderBlock tower )


doMove : TowerState -> Int -> Int -> Maybe TowerState 
doMove memory from to = 
    case Array.get from memory
     |> Maybe.map popBlock of
        Just (PopSuccess block poppedTower) ->
            case Array.get to memory
            |> Maybe.andThen (pushBlock block) of
                (Just  pushedTower) ->
                    Array.set from poppedTower memory
                    |> Array.set to pushedTower            
                    |> Just
                Nothing ->
                    Nothing
        _ -> 
            Nothing
                    

handleTick : State -> Tick -> (State, Maybe Event)
handleTick state tick =
    case state of
        Just s ->
            (state, Just (GoodMove s))    
        _ ->
            (state, Nothing)
        
handleAction : State -> Action -> (State, Maybe Event)
handleAction state action = 
    -- (state, Nothing)
    case action of
        Move x y ->        
            case state of
                Just s ->
                    let 
                        s_ = doMove s x y
                    in 
                        (s_, Nothing)
                    -- Debug.todo "Good state good move"
                Nothing ->
                    Debug.todo "Illegal move"            
        Finish ->            
            Debug.todo "Finish"

findMax : Tower -> Tower -> Tower
findMax a b = 
    if 
        List.length a > List.length b 
    then 
        a
    else
        b

puzzle : Puzzle State Event Action
puzzle =
    { init = Just (Array.fromList [ [2,3], [1], [] ])
    , view = view
    , handleTick = handleTick
    , handleAction = handleAction
    }
