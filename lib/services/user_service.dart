import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:telegram_chat/models/user.dart';
import 'package:telegram_chat/services/message_service.dart';

class UserService extends ChangeNotifier {
  MessageService messageService = MessageService();
  static final fb_store_db = FirebaseFirestore.instance.collection('users');
  User user = User(id: "", name: "", userId: "");
  Stream<QuerySnapshot> getUsers() async* {
    yield* fb_store_db.snapshots();
  }

  Future<void> addUser(String name, String user_id) async {
    user.name = name;
    user.userId = user_id;
    await fb_store_db.add({
      'name': name,
      'user_id': user_id,
    });
    notifyListeners();
  }
}
