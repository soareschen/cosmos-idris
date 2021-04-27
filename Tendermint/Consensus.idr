module Tendermint.Consensus

import Data.Vect

import Tendermint.Key
import Tendermint.Block
import Tendermint.State
import Tendermint.Validator
import Tendermint.Vote

data LockState
  = Locked
  | Unlocked

interface
  VoteImpl mod =>
  ConsensusImpl (0 mod: Type)
where
  -- A state machine for a validator for proposing a block
  -- at a given height, at a given round,
  -- depending on the incoming votes of that round from other validators.
  StateMachine :
    { 0 height: Nat } ->
    ( 0 round: Nat ) ->
    ( 0 lockState: LockState ) ->
    ( 0 phase: VotePhase ) ->
    ( 0 block: Block {mod} height ) ->
    ( 0 transactions: List (Transaction {mod}) ) ->
    Type

  GTTwoThird :
    ( count: Nat ) ->
    ( totals: Nat ) ->
    Type

  GTEOneThird :
    ( count: Nat ) ->
    ( totals: Nat ) ->
    Type

  init :
    { 0 height: Nat } ->
    ( 0 block: Block {mod} height ) ->
    ( 0 transactions: List (Transaction {mod}) ) ->
    StateMachine {height} 0 Unlocked Propose block transactions

  -- A propose stage can move forward after receiving
  -- the a propose vote from the block proposer.
  propose :
    { 0 height: Nat } ->
    ( 0 round: Nat ) ->
    ( 0 block: Block {mod} height ) ->
    ( 0 transactions: List (Transaction {mod}) ) ->
    ( 0 vote: Vote {mod} {height} round
        Propose
        (getProposer {mod} {height} block)
        block
        transactions) ->
    ( 1 state: StateMachine {height} round Unlocked Propose block transactions ) ->
    StateMachine {height} round Locked PreVote block transactions

  -- Any unlocked state machine can accept a proposal of Nil block,
  -- if the proposer did not propose within the timeout limit.
  proposeNil :
    { 0 height: Nat } ->
    ( 0 round: Nat ) ->
    ( 0 block: Block {mod} height ) ->
    ( 0 vote: Vote {mod} {height} round
        Propose
        (getProposer {mod} {height} block)
        block
        []) ->
    ( 1 state: StateMachine {height} round Unlocked Propose block [] ) ->
    StateMachine {height} round Unlocked PreVote block []

  -- Unlock the state machine and prevote,
  -- if it receives two third vote changes that is different from
  -- its locked vote.
  prevoteUnlock :
    { height: Nat } ->
    ( 0 round: Nat ) ->
    ( count: Nat ) ->
    ( totals: Nat ) ->
    ( 0 block: Block {mod} height ) ->
    ( 0 transactionsOld: List (Transaction {mod}) ) ->
    ( 0 transactionsNew: List (Transaction {mod}) ) ->
    ( 0 votes: VotesFromBlock
        mod height round PreVote count block transactionsNew ) ->
    ( 0 gtTwoThird:
        GTTwoThird count (countValidators mod height block) ) ->
    ( 1 state: StateMachine {height} round Locked PreVote block transactionsOld ) ->
    StateMachine {height} round Unlocked PreVote block transactionsNew

  -- -- A prevote stage can only move forward to precommit stage if
  -- -- there are more than two third votes received
  prevote :
    { height: Nat } ->
    ( 0 round: Nat ) ->
    ( count: Nat ) ->
    ( totals: Nat ) ->
    ( 0 block: Block {mod} height ) ->
    ( 0 transactions: List (Transaction {mod}) ) ->
    ( 0 votes: VotesFromBlock
        mod height round phase count block transactions ) ->
    ( 0 gtTwoThird:
        GTTwoThird count (countValidators mod height block) ) ->
    ( 1 state: StateMachine {height} round Locked PreVote block transactions ) ->
    StateMachine {height} round Locked PreCommit block transactions
