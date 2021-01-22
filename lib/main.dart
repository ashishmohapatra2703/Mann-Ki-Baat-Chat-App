import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  //to keep the user authenticated even if closes the app and
  //reopening would redirect him to chatscreen directly
  String getScreen() {
    if (FirebaseAuth.instance.currentUser != null) {
      return ChatScreen.id;
    } else {
      return WelcomeScreen.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      //don't use home property in place of initialRoute

      initialRoute: getScreen(),

      //Static field 'id' is accessed through the WelcomeScreen class not its object instance.
      routes: // Map<String, Widget Function(BuildContext)>
          {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
