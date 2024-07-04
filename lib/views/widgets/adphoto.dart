import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Adphoto extends StatefulWidget {
  const Adphoto({super.key});

  @override
  State<Adphoto> createState() => _AdphotoState();
}

class _AdphotoState extends State<Adphoto> {
  File? imageFile;
  Future<void> openGallery() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> openCamera() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose an option'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Gallery'),
            onTap: () async {
              Navigator.pop(context);
              await openGallery();
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () async {
              Navigator.pop(context);
              await openCamera();
            },
          ),
        ],
      ),
    );
  }
}
