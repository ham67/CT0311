package com.example.sso.kms;

import java.security.KeyPair;

public interface KmsKeyService {
    KeyPair loadSignKeyPair(String keyId);
}
