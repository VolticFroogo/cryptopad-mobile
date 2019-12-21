class Model {
    static const Protocol = "https";
    static const Host = "cryptopad.froogo.co.uk";
    static const ApiVersion = "v1";
    static const BaseUrl = "$Protocol://$Host/api/$ApiVersion/";

    static const AlgorithmPasswordHash = "SHA-512/HMAC/PBKDF2";
    static const AlgorithmCipherMode = "cbc";
    static const AlgorithmPadding = "pkcs7";

    static const EncryptionSeparator = " ";
}