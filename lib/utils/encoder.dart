import 'dart:convert';
import 'dart:io';

class Encoder {

  static String encodeToBinary(String text) {

    // List<int> bytes = text.codeUnits;
    // String binary = '';

    // for (int byte in bytes) {

    //   String byteBinary = byte.toRadixString(2).padLeft(8, '0');
    //   binary += byteBinary;
    // }

    // return binary;

    List<int> originalEncoded = utf8.encode(text);
    List<int> compressedEncoded = gzip.encode(originalEncoded);
    // print("compressedEncoded length: ${compressedEncoded.length}, originalEncoded length: ${originalEncoded.length}");
    return compressedEncoded.map((int byte) => byte.toRadixString(2).padLeft(8, '0')).join();
  }

  static String decodeFromBinary(String binary) {

    // String text = '';

    // for (int i = 0; i < binary.length; i += 8) {

    //   String byteBinary = binary.substring(i, i + 8);
    //   int byte = int.parse(byteBinary, radix: 2);
    //   text += String.fromCharCode(byte);
    // }
    
    // return text;

    List<int> compressedEncoded = binary.split('').map((String bit) => int.parse(bit)).toList();
    List<int> originalEncoded = gzip.decode(compressedEncoded);
    return utf8.decode(originalEncoded);
  }
}