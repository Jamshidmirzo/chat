import 'package:chat/services/contact_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Addcontact extends StatelessWidget {
  Addcontact({super.key});
  final contactocntroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final contactcontroller = context.read<ContactService>();
    return AlertDialog(
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Back"),
        ),
        ElevatedButton(
          onPressed: () async {
            await contactcontroller.addContact(contactocntroller.text);
            contactocntroller.clear();
            Navigator.pop(context);
          },
          child: const Text("Done"),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: contactocntroller,
            decoration: InputDecoration(
              labelText: 'Add Contact',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
