import 'package:chat/views/screens/homepage.dart';
import 'package:chat/views/screens/messagepage.dart';
import 'package:flutter/material.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  List screens = [Homepage(), Messagepage()];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          currentIndex = value;
          setState(() {});
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.contact_page_sharp), label: 'Contact'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Message'),
        ],
      ),
      body: screens[currentIndex],
    );
  }
}
