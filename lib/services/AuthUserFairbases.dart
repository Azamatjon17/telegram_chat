import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:telegram_chat/services/firebase_push_noticiction.dart';
import 'package:telegram_chat/services/user_service.dart';

class Authuserfairbases {
  final firaebase = FirebaseAuth.instance;
  final userService = UserService();

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final user = await firaebase.createUserWithEmailAndPassword(email: email, password: password);
      final userToken = await FirebasePushNoticiction.token;

      await userService.addUser(
        name,
        user.user!.uid,
        userToken!,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await firaebase.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }
}
