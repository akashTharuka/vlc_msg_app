import 'package:uuid/uuid.dart';
import 'package:vlc_msg_app/models/base_model.dart';

class Contact extends BaseModel {

  late final String id;
  final String name;
  final String publicKey;

  Contact({required this.name, required this.publicKey}){
    id = const Uuid().v1();
  }

  Contact.withId({required this.id, required this.name, required this.publicKey});

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'publicKey': publicKey,
    };
  }

  static dynamic fromMap(Map<String, dynamic> map) {

    return Contact.withId(
      id: map['id'],
      name: map['name'],
      publicKey: map['publicKey'],
    );
  }

}