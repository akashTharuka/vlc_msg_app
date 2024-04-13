import 'package:uuid/uuid.dart';
import 'package:vlc_msg_app/models/base_model.dart';

class Message extends BaseModel{

  late final String id;
  final DateTime timestamp;
  final String text;

  Message({required this.timestamp, required this.text}){
    id = const Uuid().v1();
  }

  Message.withId({required this.id, required this.timestamp, required this.text});
  
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'text': text,
    };
  }

  static dynamic fromMap(Map<String, dynamic> map) {

    return Message.withId(
      id: map['id'],
      timestamp: DateTime.parse(map['timestamp']),
      text: map['text'],
    );
  }
}