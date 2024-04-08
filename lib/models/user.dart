class User {
  
  String name;
  String privateKey;
  String publicKey;
  bool mobileUnlock;

  User({
    required this.name,
    required this.privateKey,
    required this.publicKey,
    required this.mobileUnlock,
  });
}