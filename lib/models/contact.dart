import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String id;
  String email;
  String roomId;
  Contact({required this.email, required this.id, required this.roomId});

  factory Contact.fromJson(QueryDocumentSnapshot query) {
    return Contact(
        email: query['email'], id: query.id, roomId: query['roomId']);
        
  }
}
