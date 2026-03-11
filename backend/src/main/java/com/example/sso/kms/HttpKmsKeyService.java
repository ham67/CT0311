package com.example.sso.kms;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.RequestEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.net.URI;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;
import java.util.Map;

@Service
public class HttpKmsKeyService implements KmsKeyService {

    private final RestTemplate restTemplate;
    private final String kmsEndpoint;
    private final String kmsToken;

    public HttpKmsKeyService(RestTemplateBuilder restTemplateBuilder,
                             @Value("${kms.endpoint}") String kmsEndpoint,
                             @Value("${kms.token}") String kmsToken) {
        this.restTemplate = restTemplateBuilder.build();
        this.kmsEndpoint = kmsEndpoint;
        this.kmsToken = kmsToken;
    }

    @Override
    public KeyPair loadSignKeyPair(String keyId) {
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(kmsToken);
        headers.setContentType(MediaType.APPLICATION_JSON);

        RequestEntity<Void> request = new RequestEntity<>(headers, HttpMethod.GET,
                URI.create(kmsEndpoint + "/api/kms/keys/" + keyId));

        @SuppressWarnings("unchecked")
        Map<String, String> body = restTemplate.exchange(request, Map.class).getBody();
        if (body == null || body.get("publicKeyPem") == null || body.get("privateKeyPem") == null) {
            throw new IllegalStateException("KMS 未返回有效密钥");
        }

        try {
            PublicKey publicKey = toPublicKey(body.get("publicKeyPem"));
            PrivateKey privateKey = toPrivateKey(body.get("privateKeyPem"));
            return new KeyPair(publicKey, privateKey);
        } catch (Exception ex) {
            throw new IllegalStateException("解析 KMS 密钥失败", ex);
        }
    }

    private PublicKey toPublicKey(String pem) throws Exception {
        String content = pem.replace("-----BEGIN PUBLIC KEY-----", "")
                .replace("-----END PUBLIC KEY-----", "")
                .replaceAll("\\s", "");
        byte[] encoded = Base64.getDecoder().decode(content);
        X509EncodedKeySpec spec = new X509EncodedKeySpec(encoded);
        return KeyFactory.getInstance("RSA").generatePublic(spec);
    }

    private PrivateKey toPrivateKey(String pem) throws Exception {
        String content = pem.replace("-----BEGIN PRIVATE KEY-----", "")
                .replace("-----END PRIVATE KEY-----", "")
                .replaceAll("\\s", "");
        byte[] encoded = Base64.getDecoder().decode(content);
        PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(encoded);
        return KeyFactory.getInstance("RSA").generatePrivate(spec);
    }
}
