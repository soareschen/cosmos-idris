module Tendermint.Block

import Data.Vect

import Tendermint.Key
import Tendermint.State
import Tendermint.Validator

export
interface
  ValidatorImpl mod => BlockImpl (0 mod: Type)
where
  Block: Nat -> Type

  State : Type
  Transaction : Type

  getState :
    { 0 height : Nat } ->
    Block height ->
    State

  getValidators :
    { 0 height : Nat } ->
    Block height ->
    (n ** Vect (S n) (Validator {mod}))

  getProposer :
    { 0 height : Nat } ->
    Block height ->
    Validator {mod}

export
countValidators :
  ( 0 mod: Type ) ->
  ( 0 height: Nat ) ->
  BlockImpl mod =>
  Block {mod} height ->
  Nat
countValidators _ _ block =
  S (fst (getValidators block))
