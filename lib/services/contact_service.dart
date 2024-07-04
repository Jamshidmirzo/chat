import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ContactService extends ChangeNotifier {
  final contacts = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getContacts() async* {
    yield* contacts.collection('contacts').snapshots();
  }

  Future<void> addContact(String newCont) async {
    await contacts
        .collection('contacts')
        .add({'email': newCont, 'roomId': 'qwertyuio'});
  }
}
