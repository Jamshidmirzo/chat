import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageService extends ChangeNotifier {
  final message = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessages() async* {
    yield* message.collection('messages').snapshots();
  }

  Future<void> addMesage(
      String messages, String sendId, String receiveId) async {
    await message.collection('messages').add(
      {
        'messge': messages,
        'sendId': sendId,
        'receiveId': receiveId,
      },
    );
  }
}
