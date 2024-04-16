import 'package:vlc_msg_app/models/base_model.dart';

class User extends BaseModel {
  
  String name;
  String privateKey;
  String publicKey;
  int mobileUnlock;

  User({
    required this.name,
    required this.privateKey,
    required this.publicKey,
    this.mobileUnlock = 0,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'privateKey': privateKey,
      'publicKey': publicKey,
      'mobileUnlock': mobileUnlock,
    };
  }

  static dynamic fromMap(Map<String, dynamic> map) {
    
    return User(
      name: map['name'],
      privateKey: map['privateKey'],
      publicKey: map['publicKey'],
      mobileUnlock: map['mobileUnlock'],
    );
  }
}