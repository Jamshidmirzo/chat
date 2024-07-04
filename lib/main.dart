import 'package:chat/firebase_options.dart';
import 'package:chat/services/contact_service.dart';
import 'package:chat/services/message_service.dart';
import 'package:chat/views/screens/bottomnavbar.dart';
import 'package:chat/views/screens/signinpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return ContactService();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return MessageService();
          },
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Bottomnavbar();
              } else {
                return Signinpage();
              }
            },
          )),
    );
  }
}
