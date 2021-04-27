module Tendermint.Vote

import Data.Vect

import Tendermint.Key
import Tendermint.Block
import Tendermint.State
import Tendermint.Validator

public export
data VotePhase =
  Propose |
  PreVote |
  PreCommit |
  Commit

export
interface BlockImpl mod => VoteImpl (0 mod: Type) where
  UnsignedVote :
    { 0 height: Nat } ->
    ( 0 round: Nat ) ->
    VotePhase ->
    Validator {mod} ->
    Block {mod} height ->
    List (Transaction {mod}) ->
    Type

  -- Vote for a particular list of transactions at a particular round
  -- to be added to a block at height to create a new block at height+1.
  -- If the list of transaction is empty, the Nil vote is being casted.
  Vote :
    { 0 height: Nat } ->
    ( 0 round: Nat ) ->
    VotePhase ->
    Validator {mod} ->
    Block {mod} height ->
    List (Transaction {mod}) ->
    Type

  Votes :
    { 0 height: Nat } ->
    ( 0 round: Nat ) ->
    ( 0 phase: VotePhase ) ->
    ( 0 count: Nat ) ->
    ( 0 totals: Nat ) ->
    ( 0 validators: Vect totals (Validator {mod}) ) ->
    ( 0 block: Block {mod} height ) ->
    ( 0 transactions: List (Transaction {mod}) ) ->
    Type

export
VotesFromBlock :
  ( 0 mod: Type ) ->
  VoteImpl mod =>
  ( 0 height: Nat ) ->
  ( 0 round: Nat ) ->
  ( 0 phase: VotePhase ) ->
  ( 0 count: Nat ) ->
  ( block: Block {mod} height ) ->
  ( 0 transactions: List (Transaction {mod}) ) ->
  Type
VotesFromBlock mod height round phase count block transactions =
  case getValidators {mod} {height} block of
    (totals ** validators) =>
      Votes {mod} {height} round
        phase count
        (S totals)
        validators block transactions
