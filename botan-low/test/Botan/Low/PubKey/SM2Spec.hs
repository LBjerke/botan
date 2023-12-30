module Main where

import Test.Prelude

import Botan.Low.MPI 
import Botan.Low.RNG
import Botan.Low.PubKey
import Botan.Low.PubKey.SM2

-- TODO: Consolidate
ecGroups :: [ByteString]
ecGroups =
    [ "secp160k1"
    ,  "secp160r1"
    ,  "secp160r2"
    ,  "secp192k1"
    ,  "secp192r1"
    ,  "secp224k1"
    ,  "secp224r1"
    ,  "secp256k1"
    ,  "secp256r1"
    ,  "secp384r1"
    ,  "secp521r1"
    ,  "brainpool160r1"
    ,  "brainpool192r1"
    ,  "brainpool224r1"
    ,  "brainpool256r1"
    ,  "brainpool320r1"
    ,  "brainpool384r1"
    ,  "brainpool512r1"
    ,  "x962_p192v2"
    ,  "x962_p192v3"
    ,  "x962_p239v1"
    ,  "x962_p239v2"
    ,  "x962_p239v3"
    ,  "gost_256A"
    ,  "gost_512A"
    ,  "frp256v1"
    ,  "sm2p256v1"
    ]

-- TODO: Consolidate
privKeyField :: PrivKey -> ByteString -> IO MP
privKeyField privKey field = do
    mp <- mpInit
    privKeyGetField mp privKey field
    return mp

-- TODO: Consolidate
pubKeyField :: PubKey -> ByteString -> IO MP
pubKeyField pubKey field = do
    mp <- mpInit
    pubKeyGetField mp pubKey field
    return mp

main :: IO ()
main = hspec $ testSuite ecGroups chars $ \ ecGroup -> do
    it "privKeyLoadSM2" $ do
        rng <- rngInit "system"
        privKey <- privKeyCreate "SM2" ecGroup rng
        x <- privKeyField privKey "x"
        loadedPrivKey <- privKeyLoadSM2 x ecGroup
        pass
    it "pubKeyLoadSM2" $ do
        rng <- rngInit "system"
        privKey <- privKeyCreate "SM2" ecGroup rng
        pubKey <- privKeyExportPubKey privKey
        public_x <- pubKeyField pubKey "public_x"
        public_y <- pubKeyField pubKey "public_y"
        loadedPubKey <- pubKeyLoadSM2 public_x public_y ecGroup
        pass
