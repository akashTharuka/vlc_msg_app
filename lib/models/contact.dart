import 'package:uuid/uuid.dart';

class Contact {

  late final String id;
  final String name;
  final String publicKey;

  Contact({required this.name, required this.publicKey}){
    id = const Uuid().v1();
  }

}