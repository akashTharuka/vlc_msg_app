import 'dart:developer';
import 'package:fast_rsa/fast_rsa.dart' as fast_rsa;

class RSAUtils {

  static Future<Map<String, String>> generateKeyPair() async {

    try {
      
      final keyPair = await fast_rsa.RSA.generate(2048);
      
      final publicKey = keyPair.publicKey;
      final privateKey = keyPair.privateKey;
      
      return {'publicKey': publicKey, 'privateKey': privateKey};
    } 
    on Exception catch (e) {

      log('Error generating RSA key pair: $e');
      throw Exception('Error generating RSA key pair: $e');
    }
  }

  static Future<String> encryptRSA(payload, publicKey) async => await fast_rsa.RSA
      .encryptOAEP(payload, '', fast_rsa.Hash.SHA256, publicKey);

  static Future<String> decryptRSA(payload, privateKey) async => await fast_rsa.RSA
      .decryptOAEP(payload, '', fast_rsa.Hash.SHA256, privateKey);
}