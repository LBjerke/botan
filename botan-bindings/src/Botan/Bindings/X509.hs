{-|
Module      : Botan.Bindings.X509
Description : X.509 Certificates and CRLs
Copyright   : (c) Leo D, 2023
License     : BSD-3-Clause
Maintainer  : leo@apotheca.io
Stability   : experimental
Portability : POSIX

A certificate is a binding between some identifying information
(called a subject) and a public key. This binding is asserted by
a signature on the certificate, which is placed there by some
authority (the issuer) that at least claims that it knows the
subject named in the certificate really “owns” the private key
corresponding to the public key in the certificate.

The major certificate format in use today is X.509v3, used for
instance in the Transport Layer Security (TLS) protocol.
-}

module Botan.Bindings.X509 where

import Botan.Bindings.Error
import Botan.Bindings.Prelude
import Botan.Bindings.PubKey

{-
X.509 Certificates
-}

{-|
@typedef struct botan_x509_cert_struct* botan_x509_cert_t;@
-}

data X509CertStruct
type X509CertPtr = Ptr X509CertStruct

{-|
@BOTAN_PUBLIC_API(2,0) int botan_x509_cert_load(botan_x509_cert_t* cert_obj, const uint8_t cert[], size_t cert_len);@
-}
foreign import ccall unsafe botan_x509_cert_load :: Ptr X509CertPtr -> Ptr Word8 -> CSize -> IO BotanErrorCode

{-|
@BOTAN_PUBLIC_API(2,0) int botan_x509_cert_load_file(botan_x509_cert_t* cert_obj, const char* filename);@
-}
foreign import ccall unsafe botan_x509_cert_load_file :: Ptr X509CertPtr -> CString -> IO BotanErrorCode

{-|
- \@return 0 if success, error if invalid object handle

@BOTAN_PUBLIC_API(2,0) int botan_x509_cert_destroy(botan_x509_cert_t cert);@
-}
foreign import ccall unsafe "&botan_x509_cert_destroy" botan_x509_cert_destroy :: FinalizerPtr X509CertStruct

{-|
@BOTAN_PUBLIC_API(2,8) int botan_x509_cert_dup(botan_x509_cert_t* new_cert, botan_x509_cert_t cert);@
-}
foreign import ccall unsafe botan_x509_cert_dup :: Ptr X509CertPtr -> X509CertPtr -> IO BotanErrorCode

{-|
@BOTAN_PUBLIC_API(2,0) int botan_x509_cert_get_time_starts(botan_x509_cert_t cert, char out[], size_t* out_len);@
-}
foreign import ccall unsafe botan_x509_cert_get_time_starts :: X509CertPtr -> Ptr CChar -> Ptr CSize -> IO BotanErrorCode

{-|
@BOTAN_PUBLIC_API(2,0) int botan_x509_cert_get_time_expires(botan_x509_cert_t cert, char out[], size_t* out_len);@
-}
foreign import ccall unsafe botan_x509_cert_get_time_expires :: X509CertPtr -> Ptr CChar -> Ptr CSize -> IO BotanErrorCode

{-|
@BOTAN_PUBLIC_API(2,8) int botan_x509_cert_not_before(botan_x509_cert_t cert, uint64_t* time_since_epoch);@
-}
foreign import ccall unsafe botan_x509_cert_not_before :: X509CertPtr -> Ptr Word64 -> IO BotanErrorCode
{-|
@BOTAN_PUBLIC_API(2,8) int botan_x509_cert_not_after(botan_x509_cert_t cert, uint64_t* time_since_epoch);@
-}
foreign import ccall unsafe botan_x509_cert_not_after :: X509CertPtr -> Ptr Word64 -> IO BotanErrorCode

{-|
@BOTAN_PUBLIC_API(2,0) int botan_x509_cert_get_fingerprint(botan_x509_cert_t cert, const char* hash, uint8_t out[], size_t* out_len);@
-}
foreign import ccall unsafe botan_x509_cert_get_fingerprint :: X509CertPtr -> CString -> Ptr Word8 -> Ptr CSize -> IO BotanErrorCode

{-|
@BOTAN_PUBLIC_API(2,0) int botan_x509_cert_get_serial_number(botan_x509_cert_t cert, uint8_t out[], size_t* out_len);@
-}
foreign import ccall unsafe botan_x509_cert_get_serial_number :: X509CertPtr -> Ptr Word8 -> Ptr CSize -> IO BotanErrorCode
{-|
@BOTAN_PUBLIC_API(2,0) int botan_x509_cert_get_authority_key_id(botan_x509_cert_t cert, uint8_t out[], size_t* out_len);@
-}
foreign import ccall unsafe botan_x509_cert_get_authority_key_id :: X509CertPtr -> Ptr Word8 -> Ptr CSize -> IO BotanErrorCode
{-|
@BOTAN_PUBLIC_API(2,0) int botan_x509_cert_get_subject_key_id(botan_x509_cert_t cert, uint8_t out[], size_t* out_len);@
-}
foreign import ccall unsafe botan_x509_cert_get_subject_key_id :: X509CertPtr -> Ptr Word8 -> Ptr CSize -> IO BotanErrorCode

{-|
@BOTAN_PUBLIC_API(2,0) int botan_x509_cert_get_public_key_bits(botan_x509_cert_t cert,
                                                  uint8_t out[], size_t* out_len);@
-}
foreign import ccall unsafe botan_x509_cert_get_public_key_bits :: X509CertPtr -> Ptr Word8 -> Ptr CSize -> IO BotanErrorCode

-- BOTAN_PUBLIC_API(3,0) int botan_x509_cert_view_public_key_bits(
--    botan_x509_cert_t cert,
--    botan_view_ctx ctx,
--    botan_view_bin_fn view);

{-|
@BOTAN_PUBLIC_API(2,0) int botan_x509_cert_get_public_key(botan_x509_cert_t cert, botan_pubkey_t* key);@
-}
foreign import ccall unsafe botan_x509_cert_get_public_key :: X509CertPtr -> Ptr PubKeyPtr -> IO BotanErrorCode

{-|
@BOTAN_PUBLIC_API(2,0)
int botan_x509_cert_get_issuer_dn(botan_x509_cert_t cert,
                                  const char* key, size_t index,
                                  uint8_t out[], size_t* out_len);@
-}
foreign import ccall unsafe botan_x509_cert_get_issuer_dn :: X509CertPtr -> CString -> CSize -> Ptr Word8 -> Ptr CSize -> IO BotanErrorCode

{-|
@BOTAN_PUBLIC_API(2,0)
int botan_x509_cert_get_subject_dn(botan_x509_cert_t cert,
                                   const char* key, size_t index,
                                   uint8_t out[], size_t* out_len);@
-}
foreign import ccall unsafe botan_x509_cert_get_subject_dn :: X509CertPtr -> CString -> CSize -> Ptr Word8 -> Ptr CSize -> IO BotanErrorCode

{-|
@BOTAN_PUBLIC_API(2,0) int botan_x509_cert_to_string(botan_x509_cert_t cert, char out[], size_t* out_len);@
-}
foreign import ccall unsafe botan_x509_cert_to_string :: X509CertPtr -> Ptr CChar -> Ptr CSize -> IO BotanErrorCode

-- BOTAN_PUBLIC_API(3,0) int botan_x509_cert_view_as_string(
--    botan_x509_cert_t cert,
--    botan_view_ctx ctx,
--    botan_view_str_fn view);

{-| Must match values of Key_Constraints in key_constraints.h -}
-- enum botan_x509_cert_key_constraints {
--    NO_CONSTRAINTS     = 0,
--    DIGITAL_SIGNATURE  = 32768,
--    NON_REPUDIATION    = 16384,
--    KEY_ENCIPHERMENT   = 8192,
--    DATA_ENCIPHERMENT  = 4096,
--    KEY_AGREEMENT      = 2048,
--    KEY_CERT_SIGN      = 1024,
--    CRL_SIGN           = 512,
--    ENCIPHER_ONLY      = 256,
--    DECIPHER_ONLY      = 128
-- };

type X509CertKeyConstraints = CInt

pattern BOTAN_X509_CERT_KEY_CONSTRAINTS_NO_CONSTRAINTS     = 0      :: X509CertKeyConstraints
pattern BOTAN_X509_CERT_KEY_CONSTRAINTS_DIGITAL_SIGNATURE  = 32768  :: X509CertKeyConstraints
pattern BOTAN_X509_CERT_KEY_CONSTRAINTS_NON_REPUDIATION    = 16384  :: X509CertKeyConstraints
pattern BOTAN_X509_CERT_KEY_CONSTRAINTS_KEY_ENCIPHERMENT   = 8192   :: X509CertKeyConstraints
pattern BOTAN_X509_CERT_KEY_CONSTRAINTS_DATA_ENCIPHERMENT  = 4096   :: X509CertKeyConstraints
pattern BOTAN_X509_CERT_KEY_CONSTRAINTS_KEY_AGREEMENT      = 2048   :: X509CertKeyConstraints
pattern BOTAN_X509_CERT_KEY_CONSTRAINTS_KEY_CERT_SIGN      = 1024   :: X509CertKeyConstraints
pattern BOTAN_X509_CERT_KEY_CONSTRAINTS_CRL_SIGN           = 512    :: X509CertKeyConstraints
pattern BOTAN_X509_CERT_KEY_CONSTRAINTS_ENCIPHER_ONLY      = 256    :: X509CertKeyConstraints
pattern BOTAN_X509_CERT_KEY_CONSTRAINTS_DECIPHER_ONLY      = 128    :: X509CertKeyConstraints

{-|
@BOTAN_PUBLIC_API(2,0) int botan_x509_cert_allowed_usage(botan_x509_cert_t cert, unsigned int key_usage);@
-}
foreign import ccall unsafe botan_x509_cert_allowed_usage :: X509CertPtr -> X509CertKeyConstraints -> IO BotanErrorCode

{-|
Check if the certificate matches the specified hostname via alternative name or CN match.
RFC 5280 wildcards also supported.

@BOTAN_PUBLIC_API(2,5) int botan_x509_cert_hostname_match(botan_x509_cert_t cert, const char* hostname);@
-}
foreign import ccall unsafe botan_x509_cert_hostname_match :: X509CertPtr -> CString -> IO BotanErrorCode

{-|
Returns 0 if the validation was successful, 1 if validation failed,
and negative on error. A status code with details is written to
*validation_result

Intermediates or trusted lists can be null
Trusted path can be null

@BOTAN_PUBLIC_API(2,8) int botan_x509_cert_verify(
    int* validation_result,
    botan_x509_cert_t cert,
    const botan_x509_cert_t* intermediates,
    size_t intermediates_len,
    const botan_x509_cert_t* trusted,
    size_t trusted_len,
    const char* trusted_path,
    size_t required_strength,
    const char* hostname,
    uint64_t reference_time);@
-}
foreign import ccall unsafe botan_x509_cert_verify
    :: Ptr CInt         -- Validation result
    -> X509CertPtr      -- Cert
    -> Ptr X509CertPtr  -- Intermediates
    -> CSize            -- Intermediates len
    -> Ptr X509CertPtr  -- Trusted certs
    -> CSize            -- Trusted len
    -> CString          -- Trusted path
    -> CSize            -- Required strength
    -> CString          -- Hostname
    -> Word64           -- Reference time
    -> IO BotanErrorCode

{-|
Returns a pointer to a static character string explaining the status code,
or else NULL if unknown.

@BOTAN_PUBLIC_API(2,8) const char* botan_x509_cert_validation_status(int code);@
-}
foreign import ccall unsafe botan_x509_cert_validation_status :: CInt -> IO CString

{-
X.509 CRL
-}
-- TODO: Move to X509.CRL

{-|
@typedef struct botan_x509_crl_struct* botan_x509_crl_t;@
-}

data X509CRLStruct
type X509CRLPtr = Ptr X509CRLStruct
{-|
@
BOTAN_PUBLIC_API(2,13) int botan_x509_crl_load(botan_x509_crl_t* crl_obj, const uint8_t crl_bits[], size_t crl_bits_len);@
-}
foreign import ccall unsafe botan_x509_crl_load :: Ptr X509CRLPtr -> Ptr Word8 -> CSize -> IO BotanErrorCode

{-|
@BOTAN_PUBLIC_API(2,13) int botan_x509_crl_load_file(botan_x509_crl_t* crl_obj, const char* crl_path);@
-}
foreign import ccall unsafe botan_x509_crl_load_file :: Ptr X509CRLPtr -> Ptr CChar -> IO BotanErrorCode

{-|
@BOTAN_PUBLIC_API(2,13) int botan_x509_crl_destroy(botan_x509_crl_t crl);@
-}
foreign import ccall unsafe "&botan_x509_crl_destroy" botan_x509_crl_destroy :: FinalizerPtr X509CRLStruct

{-|
Given a CRL and a certificate,
check if the certificate is revoked on that particular CRL

@BOTAN_PUBLIC_API(2,13) int botan_x509_is_revoked(botan_x509_crl_t crl, botan_x509_cert_t cert);@
-}
foreign import ccall unsafe botan_x509_is_revoked :: X509CRLPtr -> X509CertPtr -> IO BotanErrorCode

{-|
Different flavor of `botan_x509_cert_verify`, supports revocation lists.
CRLs are passed as an array, same as intermediates and trusted CAs

@BOTAN_PUBLIC_API(2,13) int botan_x509_cert_verify_with_crl(
    int* validation_result,
    botan_x509_cert_t cert,
    const botan_x509_cert_t* intermediates,
    size_t intermediates_len,
    const botan_x509_cert_t* trusted,
    size_t trusted_len,
    const botan_x509_crl_t* crls,
    size_t crls_len,
    const char* trusted_path,
    size_t required_strength,
    const char* hostname,
    uint64_t reference_time);@
-}
foreign import ccall unsafe botan_x509_cert_verify_with_crl
    :: Ptr CInt         -- Validation result
    -> X509CertPtr      -- Cert
    -> Ptr X509CertPtr  -- Intermediates
    -> CSize            -- Intermediates len
    -> Ptr X509CertPtr  -- Trusted certs
    -> CSize            -- Trusted len
    -> Ptr X509CRLPtr   -- CRLs
    -> CSize            -- CRLs len
    -> CString          -- Trusted path
    -> CSize            -- Required strength
    -> CString          -- Hostname
    -> Word64           -- Reference time
    -> IO BotanErrorCode
