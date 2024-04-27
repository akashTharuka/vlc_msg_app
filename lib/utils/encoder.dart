class Encoder {

  static String encodeToBinary(String text) {

    List<int> bytes = text.codeUnits;
    String binary = '';

    for (int byte in bytes) {

      String byteBinary = byte.toRadixString(2).padLeft(8, '0');
      binary += byteBinary;
    }

    return binary;
  }

  static String decodeFromBinary(String binary) {

    String text = '';

    for (int i = 0; i < binary.length; i += 8) {

      String byteBinary = binary.substring(i, i + 8);
      int byte = int.parse(byteBinary, radix: 2);
      text += String.fromCharCode(byte);
    }
    
    return text;
  }
}