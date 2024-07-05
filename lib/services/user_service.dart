import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:telegram_chat/models/user.dart';
import 'package:telegram_chat/services/message_service.dart';

class UserService extends ChangeNotifier {
  MessageService messageService = MessageService();
  static final fb_store_db = FirebaseFirestore.instance.collection('users');
  Stream<QuerySnapshot> getUsers() async* {
    yield* fb_store_db.snapshots();
  }

  Future<void> addUser(
    String name,
    String userId,
    String userToken,
  ) async {
    await fb_store_db.add({
      'name': name,
      'user_id': userId,
      'user_token': userToken,
    });
    notifyListeners();
  }
}
