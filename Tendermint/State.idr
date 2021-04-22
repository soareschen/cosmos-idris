module Tendermint.State

export
interface IsState (0 state : Type) where
  EqState : state -> state -> Type
  eqState : (s1: state) -> (s2: state) -> Maybe (EqState s1 s2)

  eqState_reflexivity :
    (0 s1: state) ->
    (0 s2: state) ->
    EqState s1 s2 ->
    EqState s2 s1
