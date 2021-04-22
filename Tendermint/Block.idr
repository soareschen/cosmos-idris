module Tendermint.Block

import Data.Vect

import Tendermint.Key
import Tendermint.State
import Tendermint.Validator

export
data VotePhase =
  Propose |
  PreVote |
  PreCommit |
  Commit

parameters (
  Block: Nat -> Type,
  Validator: Type,
  Transaction: Type
)
  data UnsignedVote :
    { height: Nat } ->
    VotePhase ->
    Validator ->
    Block height ->
    List Transaction ->
    Type
    where
      MkUnsignedVote :
        { height: Nat } ->
        ( phase: VotePhase ) ->
        ( validator: Validator ) ->
        ( block: Block height ) ->
        ( transactions: List Transaction ) ->
        UnsignedVote phase validator block transactions

  -- A verified vote that is casted by a validator for a block
  -- at given height with the list of proposed transactions.
  data Vote :
    { height: Nat } ->
    VotePhase ->
    Validator ->
    Block height ->
    List Transaction ->
    Type
    where
      MkVote :
        IsValidator Validator =>
        IsKey (ValidatorKey Validator) =>
        { 0 height: Nat } ->
        { 0 phase: VotePhase } ->
        ( 0 validator: Validator ) ->
        ( 0 block: Block height ) ->
        ( 0 transactions: List Transaction ) ->
        ( 0 serializer:
            UnsignedVote phase validator block transactions ->
            SignItem { Key = ValidatorKey Validator }
        ) ->
        ( vote: UnsignedVote phase validator block transactions) ->
        ( Signature
          { Key = ValidatorKey Validator }
          { Item = UnsignedVote phase validator block transactions }
          ( validatorPublicKey validator )
          serializer
          vote
        ) ->
        Vote phase validator block transactions

  data Votes :
    { 0 height: Nat } ->
    ( 0 phase: VotePhase ) ->
    ( 0 count: Nat ) ->
    ( 0 totals: Nat ) ->
    ( 0 validators: Vect totals Validator ) ->
    ( 0 block: Block height ) ->
    ( 0 transactions: List Transaction ) ->
    Type
    where
      EmptyVote :
        { 0 phase: VotePhase } ->
        { 0 height: Nat } ->
        ( 0 block: Block height ) ->
        ( 0 transactions: List Transaction ) ->
        Votes
          phase
          0
          0
          Nil
          block
          transactions

      YesVote :
        { 0 phase: VotePhase } ->
        { 0 height: Nat } ->
        { 0 count: Nat } ->
        { 0 totals: Nat } ->
        { 0 validators: Vect totals Validator } ->
        ( 0 block: Block height ) ->
        ( 0 validator: Validator ) ->
        ( 0 transactions: List Transaction ) ->
        ( vote: UnsignedVote phase validator block transactions) ->
        ( otherVotes:
            Votes
              phase count totals validators block transactions) ->
        Votes
          phase
          (S count)
          (S totals)
          (validator :: validators)
          block
          transactions

      NoVote :
        { 0 phase: VotePhase } ->
        { 0 height: Nat } ->
        { 0 count: Nat } ->
        { 0 totals: Nat } ->
        { 0 validators: Vect totals Validator } ->
        ( 0 block: Block height ) ->
        ( 0 validator: Validator ) ->
        ( 0 transactions: List Transaction ) ->
        ( otherVotes:
            Votes phase count totals validators block transactions) ->
        Votes
          phase
          count
          (S totals)
          (validator :: validators)
          block
          transactions

export
interface
  IsBlock (0 Block : Nat -> Type)
where
  State : Type
  Validator : Type
  Transaction : Type

  getState :
    { 0 height : Nat } ->
    Block height ->
    State

  getValidators :
    { 0 height : Nat } ->
    Block height ->
    (n ** Vect (S n) Validator)

  getProposer :
    { 0 height : Nat } ->
    Block height ->
    Validator
