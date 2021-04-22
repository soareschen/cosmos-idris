module Tendermint.App

import Tendermint.State

interface
  App (0 app : Type)
where
  state : Type
  transaction : Type
  updateErr : Type

  update :
    transaction ->
    state ->
    Either updateErr state
