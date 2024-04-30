import 'dart:convert';
import 'dart:developer';
import 'package:fast_rsa/fast_rsa.dart' as fast_rsa;
import 'package:crypto/crypto.dart' as crypto;
import 'package:encrypt/encrypt.dart' as encrypt;

class RSAUtils {
  static const int keySize = 512;
  static const fast_rsa.Hash hash = fast_rsa.Hash.SHA256;
  static const String label = '';

  static Future<Map<String, String>> generateKeyPair() async {

    try {
      final keyPair = await fast_rsa.RSA.generate(keySize);
      final publicKey = keyPair.publicKey;
      final privateKey = keyPair.privateKey;

      return {'publicKey': publicKey, 'privateKey': privateKey};
    } 
    on Exception catch (e) {
      log('Error generating RSA key pair: $e');
      throw Exception('Error generating RSA key pair: $e');
    }
  }

  static Future<String> encryptRSA(payload, publicKey) async {
    try {
      return await fast_rsa.RSA.encryptOAEP(payload, label, hash, publicKey);
    } 
    on Exception catch (e) {
      log('Error encrypting RSA: $e');
      throw Exception('Error encrypting RSA: $e');
    }
  
  }

  static Future<String> decryptRSA(payload, privateKey) async {
    try {
      return await fast_rsa.RSA.decryptOAEP(payload, label, hash, privateKey);
    } 
    on Exception catch (e) {
      log('Error decrypting RSA: $e');
      throw Exception('Error decrypting RSA: $e');
    }
  }

  static String generateAESKey() {
    final key = crypto.md5.convert(utf8.encode(DateTime.now().toString())).toString();
    return key.substring(0, 16); // AES key must be 16 bytes
  }

  static String encryptAES(String payload, String key) {
    final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(key)));
    final encrypted = encrypter.encrypt(payload);
    return encrypted.base64;
  }

  static String decryptAES(String payload, String key) {
    final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(key)));
    final decrypted = encrypter.decrypt64(payload);
    return decrypted;
  }
}