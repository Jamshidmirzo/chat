import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String message;
  String sendId;
  String receiveId;
  String id;
  Message(
      {required this.id,
      required this.message,
      required this.receiveId,
      required this.sendId});
  factory Message.fromJson(QueryDocumentSnapshot query) {
    return Message(
        id: query.id,
        message: query['messge'],
        receiveId: query['receiveId'],
        sendId: query['sendId']);
  }
}
