import 'dart:io';

import 'package:chat/models/contact.dart';
import 'package:chat/views/widgets/adphoto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Chatpage extends StatefulWidget {
  final Contact contact;
  const Chatpage({super.key, required this.contact});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  final _firestore = FirebaseFirestore.instance;
  final textController = TextEditingController();
  late final String chatroomId;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    final smth = [
      widget.contact.email,
      FirebaseAuth.instance.currentUser!.email!
    ];
    chatroomId = smth.join();
  }

  void showImageSourceDialog() async {
    final responce = await showDialog(
      context: context,
      builder: (context) {
        return Adphoto();
      },
    );
    if (responce != null) {
      print(responce);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.contact.email}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _firestore
                    .collection('chat-room')
                    .doc(chatroomId)
                    .collection('messages')
                    .orderBy('timeStamp', descending: true)
                    .snapshots(),
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
                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                          'You don’t have any messages with ${widget.contact.email}. Send the first message!'),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final messages = snapshot.data!.docs;
                      return ListTile(
                        title: Text(messages[index]['text']),
                        subtitle: Text(messages[index]['senderId']),
                      );
                    },
                  );
                },
              ),
            ),
            TextFormField(
              controller: textController,
              decoration: InputDecoration(
                prefixIcon: ZoomTapAnimation(
                  onTap: showImageSourceDialog,
                  child: const Icon(Icons.photo),
                ),
                hintText: 'Write...',
                suffixIcon: IconButton(
                  onPressed: () async {
                    if (textController.text.isNotEmpty || imageFile != null) {
                      await _firestore
                          .collection('chat-room')
                          .doc(chatroomId)
                          .collection('messages')
                          .add({
                        'text': textController.text,
                        'senderId': FirebaseAuth.instance.currentUser!.email!,
                        'timeStamp': FieldValue.serverTimestamp(),
                        'imageUrl': imageFile != null ? imageFile!.path : null,
                      });
                      textController.clear();
                      setState(() {
                        imageFile = null;
                      });
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
