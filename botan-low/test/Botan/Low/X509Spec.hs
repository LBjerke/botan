module Botan.Low.X509Spec
( spec
) where

import Test.Prelude

import Botan.Low.X509

import Paths_botan_low

testCert :: ByteString
testCert = "-----BEGIN CERTIFICATE-----\
\MIID2jCCA0MCAg39MA0GCSqGSIb3DQEBBQUAMIGbMQswCQYDVQQGEwJKUDEOMAwG\
\A1UECBMFVG9reW8xEDAOBgNVBAcTB0NodW8ta3UxETAPBgNVBAoTCEZyYW5rNERE\
\MRgwFgYDVQQLEw9XZWJDZXJ0IFN1cHBvcnQxGDAWBgNVBAMTD0ZyYW5rNEREIFdl\
\YiBDQTEjMCEGCSqGSIb3DQEJARYUc3VwcG9ydEBmcmFuazRkZC5jb20wHhcNMTIw\
\ODIyMDUyODAwWhcNMTcwODIxMDUyODAwWjBKMQswCQYDVQQGEwJKUDEOMAwGA1UE\
\CAwFVG9reW8xETAPBgNVBAoMCEZyYW5rNEREMRgwFgYDVQQDDA93d3cuZXhhbXBs\
\ZS5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCwvWITOLeyTbS1\
\Q/UacqeILIK16UHLvSymIlbbiT7mpD4SMwB343xpIlXN64fC0Y1ylT6LLeX4St7A\
\cJrGIV3AMmJcsDsNzgo577LqtNvnOkLH0GojisFEKQiREX6gOgq9tWSqwaENccTE\
\sAXuV6AQ1ST+G16s00iN92hjX9V/V66snRwTsJ/p4WRpLSdAj4272hiM19qIg9zr\
\h92e2rQy7E/UShW4gpOrhg2f6fcCBm+aXIga+qxaSLchcDUvPXrpIxTd/OWQ23Qh\
\vIEzkGbPlBA8J7Nw9KCyaxbYMBFb1i0lBjwKLjmcoihiI7PVthAOu/B71D2hKcFj\
\Kpfv4D1Uam/0VumKwhwuhZVNjLq1BR1FKRJ1CioLG4wCTr0LVgtvvUyhFrS+3PdU\
\R0T5HlAQWPMyQDHgCpbOHW0wc0hbuNeO/lS82LjieGNFxKmMBFF9lsN2zsA6Qw32\
\Xkb2/EFltXCtpuOwVztdk4MDrnaDXy9zMZuqFHpv5lWTbDVwDdyEQNclYlbAEbDe\
\vEQo/rAOZFl94Mu63rAgLiPeZN4IdS/48or5KaQaCOe0DuAb4GWNIQ42cYQ5TsEH\
\Wt+FIOAMSpf9hNPjDeu1uff40DOtsiyGeX9NViqKtttaHpvd7rb2zsasbcAGUl+f\
\NQJj4qImPSB9ThqZqPTukEcM/NtbeQIDAQABMA0GCSqGSIb3DQEBBQUAA4GBAIAi\
\gU3My8kYYniDuKEXSJmbVB+K1upHxWDA8R6KMZGXfbe5BRd8s40cY6JBYL52Tgqd\
\l8z5Ek8dC4NNpfpcZc/teT1WqiO2wnpGHjgMDuDL1mxCZNL422jHpiPWkWp3AuDI\
\c7tL1QjbfAUHAQYwmHkWgPP+T2wAv0pOt36GgMCM\
\-----END CERTIFICATE-----\
\"

-- NOTE: Taken from https://fm4dd.com/openssl/certexamples.shtm
testCertFile :: FilePath
testCertFile = "test-data/4096b-rsa-example-cert.pem"

testCertHostname :: ByteString
testCertHostname = "foo.com"

spec :: Spec
spec = focus $ do
    it "x509CertLoad" $ do
        cert <- x509CertLoad testCert
        pass
    it "x509CertLoadFile" $ do
        cert <- x509CertLoadFile =<< getDataFileName testCertFile
        pass
    it "x509CertDup" $ do
        cert <- x509CertLoad testCert
        dup <- x509CertDup cert
        -- TODO: parity check, eg:  x509CertGetPublicKey cert == x509CertGetPublicKey dup
        pass
    it "x509CertGetTimeStarts" $ do
        cert <- x509CertLoad testCert
        ts <- x509CertGetTimeStarts cert
        pass
    it "x509CertGetTimeExpires" $ do
        cert <- x509CertLoad testCert
        te <- x509CertGetTimeExpires cert
        pass
    it "x509CertNotBefore" $ do
        cert <- x509CertLoad testCert
        nb <- x509CertNotBefore cert
        pass
    it "x509CertNotAfter" $ do
        cert <- x509CertLoad testCert
        na <- x509CertNotAfter cert
        pass
    it "x509CertGetPubKeyFingerprint" $ do
        cert <- x509CertLoad testCert
        fp <- x509CertGetPubKeyFingerprint cert "SHA-256" -- TODO: HashName
        pass
    it "x509CertGetSerialNumber" $ do
        cert <- x509CertLoad testCert
        sn <- x509CertGetSerialNumber cert
        pass
    it "x509CertGetAuthorityKeyId" $ do
        cert <- x509CertLoad testCert
        akid <- x509CertGetAuthorityKeyId cert
        pass
    it "x509CertGetSubjectKeyId" $ do
        cert <- x509CertLoad testCert
        sid <- x509CertGetSubjectKeyId cert
        pass
    it "x509CertGetPublicKeyBits" $ do
        cert <- x509CertLoad testCert
        pkbits <- x509CertGetPublicKeyBits cert
        pass
    it "x509CertGetPublicKey" $ do
        cert <- x509CertLoad testCert
        pk <- x509CertGetPublicKey cert
        pass
    it "x509CertGetIssuerDN" $ do
        cert <- x509CertLoad testCert
        _ <- x509CertGetIssuerDN cert "CN" 0 -- TODO: Distinguished names, etc
        pass
    it "x509CertGetSubjectDN" $ do
        cert <- x509CertLoad testCert
        _ <- x509CertGetSubjectDN cert "CN" 0 -- TODO: Distinguished names, etc
        pass
    it "x509CertToString" $ do
        cert <- x509CertLoad testCert
        pass
    it "x509CertAllowedUsage" $ do
        cert <- x509CertLoad testCert
        allowed <- x509CertAllowedUsage cert NoConstraints
        pass
    it "x509CertHostnameMatch" $ do
        cert <- x509CertLoad testCert
        matched <- x509CertHostnameMatch cert testCertHostname
        pass
    it "x509CertVerify" $ do
        cert <- x509CertLoad testCert
        -- x509CertVerify cert
        pending
    it "x509CertValidationStatus" $ do
        cert <- x509CertLoad testCert
        -- x509CertValidationStatus cert
        pending
    it "x509CRLLoad" $ do
        cert <- x509CertLoad testCert
        -- x509CRLLoad cert
        pending
    it "x509CRLLoadFile" $ do
        cert <- x509CertLoad testCert
        -- x509CRLLoadFile cert
        pending
    it "x509IsRevoked" $ do
        cert <- x509CertLoad testCert
        -- x509IsRevoked cert
        pending
    it "x509CertVerifyWithCLR" $ do
        cert <- x509CertLoad testCert
        -- x509CertVerifyWithCLR cert
        pending

