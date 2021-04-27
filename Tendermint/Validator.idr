module Tendermint.Validator

import Tendermint.Key

export
interface
  KeyImpl mod => ValidatorImpl (0 mod: Type)
where
  Validator : Type

  export
  getPublicKey :
    Validator ->
    PublicKey {mod}

-- export
-- ValidatorKey :
--   ( 0 Validator: Type ) ->
--   IsValidator Validator =>
--   Type
-- ValidatorKey validatorT = Key { Validator = validatorT }

-- export
-- ValidatorSignItem :
--   ( 0 Validator: Type ) ->
--   IsValidator Validator =>
--   IsKey (ValidatorKey Validator) =>
--   Type
-- ValidatorSignItem validatorT = SignItem { Key = ValidatorKey validatorT }

-- export
-- ValidatorPublicKey :
--   ( 0 Validator: Type ) ->
--   IsValidator Validator =>
--   IsKey (ValidatorKey Validator) =>
--   Type
-- ValidatorPublicKey validatorT =
--   PublicKey { Key = ValidatorKey validatorT }

-- export
-- ValidatorPrivateKey :
--   { 0 Validator: Type } ->
--   IsValidator Validator =>
--   IsKey (ValidatorKey Validator) =>
--   (validator: Validator) ->
--   Type
-- ValidatorPrivateKey validator =
--   PrivateKey { Key = ValidatorKey Validator }
--     (getPublicKey validator)

-- export
-- validatorPublicKey :
--   { 0 Validator: Type } ->
--   IsValidator Validator =>
--   IsKey (ValidatorKey Validator) =>
--   (validator: Validator) ->
--   PublicKey { Key = ValidatorKey Validator }
-- validatorPublicKey validator = getPublicKey validator
