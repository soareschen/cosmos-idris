module Tendermint.Key

export
interface KeyImpl (0 mod: Type) where
  PublicKey : Type
  PrivateKey : PublicKey -> Type

  SignItem : Type

  Signature :
    { 0 Item: Type } ->
    PublicKey ->
    ( Item -> SignItem ) ->
    Item ->
    Type

  UnverifiedSignature :
    { 0 Item: Type } ->
    ( Item -> SignItem ) ->
    Item ->
    Type

  generateKeyPair :
    ( publicKey: PublicKey ** PrivateKey publicKey )

  sign :
    { Item: Type } ->
    ( publicKey: PublicKey ) ->
    ( privateKey: PrivateKey publicKey ) ->
    ( serializer: Item -> SignItem ) ->
    ( item: Item ) ->
    Signature publicKey serializer item

  verifySignature :
    { Item: Type } ->
    ( publicKey: PublicKey ) ->
    ( serializer: Item -> SignItem ) ->
    ( item: Item ) ->
    ( signature: UnverifiedSignature serializer item ) ->
    Maybe (Signature publicKey serializer item)
