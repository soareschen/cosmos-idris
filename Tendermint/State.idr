module Tendermint.State

export
interface StateImpl (0 mod: Type) where
  State : Type

  EqState : State -> State -> Type
  eqState : (s1: State) -> (s2: State) -> Maybe (EqState s1 s2)

  eqState_reflexivity :
    (0 s1: State) ->
    (0 s2: State) ->
    EqState s1 s2 ->
    EqState s2 s1
