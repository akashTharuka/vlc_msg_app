import 'package:uuid/uuid.dart';

class Message {

  late final String id;
  final DateTime timestamp;
  final String text;

  Message({required this.timestamp, required this.text}){
    id = const Uuid().v1();
  }
}