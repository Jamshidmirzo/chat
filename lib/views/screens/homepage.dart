import 'package:chat/models/contact.dart';
import 'package:chat/services/contact_service.dart';
import 'package:chat/views/screens/chatpage.dart';
import 'package:chat/views/widgets/addcontact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool isSearch = false;
  addCont() {
    showDialog(
      context: context,
      builder: (context) {
        return Addcontact();
      },
    );
  }

  Stream<QuerySnapshot> searchContacts(String query) {
    final contactsService = context.read<ContactService>();
    if (query.isEmpty) {
      return contactsService.getContacts();
    } else {
      return contactsService.contacts
          .collection('contacts')
          .where('email', isGreaterThanOrEqualTo: query)
          .where('email', isLessThanOrEqualTo: query + '\uf8ff')
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ZoomTapAnimation(
          onTap: () {
            isSearch = !isSearch;
            setState(() {});
          },
          child: const Icon(Icons.search),
        ),
        title: isSearch
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search contacts...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Text("Contacts"),
        actions: [IconButton(onPressed: addCont, icon: const Icon(Icons.add))],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: searchContacts(_searchQuery),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No contacts found.'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final contacts = snapshot.data!.docs;
                final contact = Contact.fromJson(contacts[index]);
                return ZoomTapAnimation(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Chatpage(contact: contact);
                        },
                      ),
                    );
                  },
                  child: ListTile(
                    leading: const CircleAvatar(),
                    title: Text(contact.email),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                );
              },
            );
          }),
    );
  }
}
