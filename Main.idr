module Main

import Control.App
import Control.App.Console

import Tendermint

hello : Console es => App es ()
hello = putStrLn "Hello, App world!"

main : IO ()
main = run hello
