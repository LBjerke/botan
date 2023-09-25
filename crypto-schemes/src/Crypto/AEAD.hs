module Crypto.AEAD where

import Crypto.Prelude

data family Key a
data family Nonce a
data family AdditionalData aead
data family Tag aead
data family Ciphertext aead
data family CombinedCiphertext aead

class AE ae where

    aeSealDetached :: Key ae -> Nonce ae -> Message -> (Tag ae, Ciphertext ae)

    -- aeSealDetached from aeadSealDetached
    -- default aeSealDetached :: (AEAD ae) => Key ae -> Nonce ae -> Message -> (Tag ae, Ciphertext ae)
    -- aeSealDetached k n msg = aeadSealDetached k n msg ""

    aeOpenDetached :: Key ae -> Nonce ae -> Tag ae -> Ciphertext ae -> Maybe Message

    -- aeOpenDetached from aeadOpenDetached
    -- default aeOpenDetached :: (AEAD ae) => Key ae -> Nonce ae -> Tag ae -> Ciphertext ae -> Maybe Message
    -- aeOpenDetached k n t ct = aeadOpenDetached k n t ct ""

-- TODO:
-- data AEMode
--     = EtM Cipher MAC
--     | ...

-- class AE aead => AEAD aead where
    -- ...

class AEAD aead where

    aeadSeal :: Key aead -> Nonce aead -> Message -> AdditionalData aead -> CombinedCiphertext aead
    -- aeadSeal k n msg ad = uncurry combineCiphertext . aeadSealDetached k n t ct ad
    aeadOpen :: Key aead -> Nonce aead -> CombinedCiphertext aead -> AdditionalData aead -> Maybe Message
    -- aeadOpen k n cct ad = aeadOpenDetached k n t ct ad where
    --     (t,ct) = splitCiphertext t ct 

    aeadSealDetached :: Key aead -> Nonce aead -> Message -> AdditionalData aead -> (Tag aead, Ciphertext aead)
    aeadOpenDetached :: Key aead -> Nonce aead -> Tag aead -> Ciphertext aead -> AdditionalData aead -> Maybe Message

    -- Support

    tagLength :: proxy aead -> Int

    combineCiphertext :: Tag aead -> Ciphertext aead -> CombinedCiphertext aead
    -- combineCiphertext tag ciphertext = bytes tag <> bytes ciphertext
    splitCiphertext :: CombinedCiphertext aead -> (Tag aead, Ciphertext aead)
    -- splitCiphertext cct = (fromBytes tag, fromBytes ciphertext) where
    --     (tag,ciphertext) = splitAtEnd (tagLength k) cct