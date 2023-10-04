{-|
Module      : Botan.Low.Ed25519
Description : Algorithm specific key operations: Ed25519
Copyright   : (c) Leo D, 2023
License     : BSD-3-Clause
Maintainer  : leo@apotheca.io
Stability   : experimental
Portability : POSIX
-}

module Botan.Low.PubKey.Ed25519 where

import qualified Data.ByteString as ByteString

import Botan.Bindings.PubKey
import Botan.Bindings.PubKey.Ed25519

import Botan.Low.Error
import Botan.Low.Make
import Botan.Low.Prelude
import Botan.Low.PubKey

-- /*
-- * Algorithm specific key operations: Ed25519
-- */

-- NOTE: Input must be exactly 32 bytes long
privKeyLoadEd25519 :: ByteString -> IO PrivKey
privKeyLoadEd25519 = mkInit_bytes MkPrivKey botan_privkey_load_ed25519 botan_privkey_destroy

-- NOTE: Input must be exactly 32 bytes long
pubKeyLoadEd25519 :: ByteString -> IO PubKey
pubKeyLoadEd25519 = mkInit_bytes MkPubKey botan_pubkey_load_ed25519 botan_pubkey_destroy

privKeyEd25519GetPrivKey :: PrivKey -> IO ByteString
privKeyEd25519GetPrivKey sk = withPrivKeyPtr sk $ \ skPtr -> do
    allocBytes 64 $ \ outPtr -> do
        throwBotanIfNegative_ $ botan_privkey_ed25519_get_privkey skPtr outPtr

pubKeyEd25519GetPubKey :: PubKey -> IO ByteString
pubKeyEd25519GetPubKey pk = withPubKeyPtr pk $ \ pkPtr -> do
    allocBytes 32 $ \ outPtr -> do
        throwBotanIfNegative_ $ botan_pubkey_ed25519_get_pubkey pkPtr outPtr
