import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telegram_chat/models/message.dart';

class MessageService {
  Stream<QuerySnapshot> getMessages(String chatRoomID) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore.collection("chatrooms").doc(chatRoomID).collection("messages").orderBy("dateTime").snapshots();
  }

  Future<void> addMessage(
    Message message,
    String chatRoomId,
  ) async {
    await FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomId).collection('messages').add({
      'text': message.text,
      'sender-id': message.senderId,
      'dateTime': message.dateTime.toString(),
    });
  }

  Future<void> deleteMessage(String id,String chatRoomId) async {
    await FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomId).collection('messages').doc(id).delete();
  }
}
