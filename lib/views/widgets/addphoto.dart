import 'dart:io';

import 'package:chat/services/contact_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Alerdiaolog extends StatefulWidget {
  const Alerdiaolog({super.key});

  @override
  State<Alerdiaolog> createState() => _AlerdiaologState();
}

class _AlerdiaologState extends State<Alerdiaolog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  bool _isLoading = false;
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
    final productController = context.read<ContactService>();
    return AlertDialog(
      actions: !_isLoading
          ? [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Back"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.isEmpty ||
                          priceController.text.isEmpty ||
                          imageFile == null) {
                        // Handle empty fields
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please fill all fields and select an image'),
                          ),
                        );
                        return;
                      }
                      _isLoading = true;
                      print('object');
                      setState(() {});
                      try {
                        await productController.addContact(
                          nameController.text,
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                        setState(() {});
                      } catch (e) {
                        // Handle error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error adding product: $e'),
                          ),
                        );
                      } finally {
                        _isLoading = false;
                        setState(() {});
                      }
                    },
                    child: const Text("Done"),
                  )
                ],
              ),
            ]
          : [CircularProgressIndicator()],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add product',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
          ),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: priceController,
            decoration: InputDecoration(
              labelText: 'Price',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ZoomTapAnimation(
                onTap: openCamera,
                child: const Icon(Icons.camera),
              ),
              ZoomTapAnimation(
                onTap: openGallery,
                child: const Icon(Icons.image),
              ),
            ],
          ),
          if (imageFile != null)
            SizedBox(
              width: 200,
              height: 200,
              child: Image.file(imageFile!, fit: BoxFit.cover),
            ),
        ],
      ),
    );
    ;
  }
}
