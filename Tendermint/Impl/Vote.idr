module Tendermint.Impl.Vote

import Data.Vect

import Tendermint.Key
import Tendermint.Block
import Tendermint.State
import Tendermint.Validator
import Tendermint.Vote

export
data UnsignedVote :
  { auto 0 mod: Type } ->
  BlockImpl mod =>
  { auto 0 height: Nat } ->
  VotePhase ->
  Validator {mod} ->
  Block {mod} height ->
  List (Transaction {mod}) ->
  Type
  where
    MkUnsignedVote :
      { 0 mod: Type } ->
      BlockImpl mod =>
      { height: Nat } ->
      ( phase: VotePhase ) ->
      ( validator: Validator {mod} ) ->
      ( block: Block {mod} height ) ->
      ( transactions: List (Transaction {mod}) ) ->
      UnsignedVote phase validator block transactions

-- A verified vote that is casted by a validator for a block
-- at given height with the list of proposed transactions.
export
data Vote :
  { auto 0 mod: Type } ->
  BlockImpl mod =>
  { auto 0 height: Nat } ->
  VotePhase ->
  Validator {mod} ->
  Block {mod} height ->
  List (Transaction {mod}) ->
  Type
  where
    MkVote :
      { 0 mod: Type } ->
      BlockImpl mod =>
      { 0 height: Nat } ->
      { 0 phase: VotePhase } ->
      ( 0 validator: Validator {mod} ) ->
      ( 0 block: Block {mod} height ) ->
      ( 0 transactions: List (Transaction {mod}) ) ->
      ( 0 serializer:
          UnsignedVote phase validator block transactions ->
          (SignItem {mod})
      ) ->
      ( vote: UnsignedVote phase validator block transactions) ->
      ( Signature {mod}
        { Item = UnsignedVote phase validator block transactions }
        ( getPublicKey {mod} validator )
        serializer
        vote
      ) ->
      Vote phase validator block transactions

export
data Votes :
  { auto 0 mod: Type } ->
  BlockImpl mod =>
  { auto 0 height: Nat } ->
  ( 0 phase: VotePhase ) ->
  ( 0 count: Nat ) ->
  ( 0 totals: Nat ) ->
  ( 0 validators: Vect totals (Validator {mod}) ) ->
  ( 0 block: Block {mod} height ) ->
  ( 0 transactions: List (Transaction {mod}) ) ->
  Type
  where
    EmptyVote :
      { 0 mod: Type } ->
      BlockImpl mod =>
      { 0 phase: VotePhase } ->
      { 0 height: Nat } ->
      ( 0 block: Block {mod} height ) ->
      ( 0 transactions: List (Transaction {mod}) ) ->
      Votes
        phase
        0
        0
        Nil
        block
        transactions

    YesVote :
      { 0 mod: Type } ->
      BlockImpl mod =>
      { 0 phase: VotePhase } ->
      { 0 height: Nat } ->
      { 0 count: Nat } ->
      { 0 totals: Nat } ->
      { 0 validators: Vect totals (Validator {mod}) } ->
      ( 0 block: Block {mod} height ) ->
      ( 0 validator: Validator {mod} ) ->
      ( 0 transactions: List (Transaction {mod}) ) ->
      ( vote:
          UnsignedVote {height}
            phase validator block transactions) ->
      ( otherVotes:
          Votes {height}
            phase count totals validators block transactions) ->
      Votes {height}
        phase
        (S count)
        (S totals)
        (validator :: validators)
        block
        transactions

    NoVote :
      { 0 mod: Type } ->
      BlockImpl mod =>
      { 0 phase: VotePhase } ->
      { 0 height: Nat } ->
      { 0 count: Nat } ->
      { 0 totals: Nat } ->
      { 0 validators: Vect totals (Validator {mod}) } ->
      ( 0 block: Block {mod} height ) ->
      ( 0 validator: Validator {mod} ) ->
      ( 0 transactions: List (Transaction {mod}) ) ->
      ( otherVotes:
          Votes {height}
            phase count totals validators block transactions) ->
      Votes {height}
        phase
        count
        (S totals)
        (validator :: validators)
        block
        transactions
