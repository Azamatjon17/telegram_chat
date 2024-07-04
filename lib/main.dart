import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegram_chat/firebase_options.dart';
import 'package:telegram_chat/services/user_service.dart';
import 'package:telegram_chat/views/screens/home_page.dart';
import 'package:telegram_chat/views/screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => UserService(),
          ),
        ],
        builder: (context, child) {
          return MaterialApp(
            home: StreamBuilder(
              stream: FirebaseAuth.instance.userChanges(),
              builder: (context, user) {
                if (user.data == null) {
                  return LoginPage();
                } else {
                  return HomePage();
                }
              },
            ),
          );
        });
  }
}
