{-|
Module      : Botan.Low.BlockCipher
Description : Raw Block Cipher (PRP) interface
Copyright   : (c) Leo D, 2023
License     : BSD-3-Clause
Maintainer  : leo@apotheca.io
Stability   : experimental
Portability : POSIX

This is a ‘raw’ interface to ECB mode block ciphers.
Most applications want the higher level cipher API which provides authenticated encryption.
This API exists as an escape hatch for applications which need to implement custom primitives using a PRP.
-}

module Botan.Low.BlockCipher where

import qualified Data.ByteString as ByteString

import Botan.Bindings.BlockCipher

import Botan.Low.Error
import Botan.Low.Make
import Botan.Low.Prelude

-- |Opaque block cipher object
newtype BlockCipherCtx = MkBlockCipherCtx { getBlockCipherForeignPtr :: ForeignPtr BlockCipherStruct }

withBlockCipherPtr :: BlockCipherCtx -> (BlockCipherPtr -> IO a) -> IO a
withBlockCipherPtr = withForeignPtr . getBlockCipherForeignPtr

-- |Block cipher name type
type BlockCipherName = ByteString

-- |Initialize a block cipher object
blockCipherInit
    :: BlockCipherName -- ^ Cipher name
    -> IO BlockCipherCtx
blockCipherInit = mkInit_name MkBlockCipherCtx botan_block_cipher_init botan_block_cipher_destroy


-- |Destroy a block cipher object immediately
blockCipherDestroy
    :: BlockCipherCtx  -- ^ The cipher object
    -> IO ()
blockCipherDestroy blockCipher = finalizeForeignPtr (getBlockCipherForeignPtr blockCipher)

withBlockCipherInit :: BlockCipherName -> (BlockCipherCtx -> IO a) -> IO a
withBlockCipherInit = mkWithTemp1 blockCipherInit blockCipherDestroy

-- |Reinitializes the block cipher
blockCipherClear
    :: BlockCipherCtx  -- ^ The cipher object
    -> IO ()
blockCipherClear = mkAction withBlockCipherPtr botan_block_cipher_clear

-- | Set the key for a block cipher instance
--
-- Error if the key is not valid.
blockCipherSetKey
    :: BlockCipherCtx  -- ^ The cipher object
    -> ByteString   -- ^ A cipher key
    -> IO ()
blockCipherSetKey = mkSetBytesLen withBlockCipherPtr botan_block_cipher_set_key

-- |Return the positive block size of this block cipher, or negative to
--  indicate an error
blockCipherBlockSize
    :: BlockCipherCtx  -- ^ The cipher object
    -> IO Int
blockCipherBlockSize = mkGetIntCode withBlockCipherPtr botan_block_cipher_block_size

-- |Encrypt one or more blocks with the cipher
blockCipherEncryptBlocks
    :: BlockCipherCtx  -- ^ The cipher object
    -> ByteString   -- ^ The plaintext
    -> IO ByteString
blockCipherEncryptBlocks blockCipher bytes = withBlockCipherPtr blockCipher $ \ blockCipherPtr -> do
    asBytesLen bytes $ \ bytesPtr bytesLen -> do
        allocBytes (fromIntegral bytesLen) $ \ destPtr -> do
            throwBotanIfNegative_ $ botan_block_cipher_encrypt_blocks
                blockCipherPtr
                bytesPtr
                destPtr
                bytesLen

-- |Decrypt one or more blocks with the cipher
blockCipherDecryptBlocks
    :: BlockCipherCtx  -- ^ The cipher object
    -> ByteString   -- ^ The ciphertext
    -> IO ByteString
blockCipherDecryptBlocks blockCipher bytes = withBlockCipherPtr blockCipher $ \ blockCipherPtr -> do
    asBytesLen bytes $ \ bytesPtr bytesLen -> do
        allocBytes (fromIntegral bytesLen) $ \ destPtr -> do
            throwBotanIfNegative_ $ botan_block_cipher_decrypt_blocks
                blockCipherPtr
                bytesPtr
                destPtr
                bytesLen

-- |Get the name of this block cipher
blockCipherName
    :: BlockCipherCtx  -- ^ The cipher object
    -> IO BlockCipherName
blockCipherName = mkGetCString withBlockCipherPtr botan_block_cipher_name

-- |Get the key length limits of this block cipher
--
--  Returns the minimum, maximum, and modulo of valid keys.
blockCipherGetKeyspec
    :: BlockCipherCtx  -- ^ The cipher object
    -> IO (Int,Int,Int)
blockCipherGetKeyspec = mkGetSizes3 withBlockCipherPtr botan_block_cipher_get_keyspec
