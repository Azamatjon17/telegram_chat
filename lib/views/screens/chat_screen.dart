import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:telegram_chat/models/message.dart';
import 'package:telegram_chat/models/user.dart';
import 'package:telegram_chat/services/user_service.dart';

class ChatScreen extends StatefulWidget {
  final User user;
  ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String chatRoomId;

  bool isLoading = false;
  final textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    List<String> userIdList = [auth.FirebaseAuth.instance.currentUser!.uid, widget.user.userId]..sort();
    chatRoomId = userIdList.join();
  }

  @override
  void dispose() {
    textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = context.read<UserService>();
    final currentUser = auth.FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.user.name),
        ),
        body: const Center(
          child: Text("User not logged in."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(currentUser.uid == widget.user.userId ? "Me" : widget.user.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: userService.messageService.getMessages(chatRoomId),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Something went wrong"),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No messages available"),
                  );
                }

                final messages = snapshot.data!.docs;

                // Scroll to bottom when new data is loaded
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final Message message = Message(
                      id: messages[index].id,
                      senderId: messages[index]['sender-id'],
                      text: messages[index]['text'],
                      dateTime: DateTime.parse(messages[index]['dateTime']),
                    );
                    return Align(
                      alignment: message.senderId == currentUser.uid ? Alignment.centerRight : Alignment.centerLeft,
                      child: InkWell(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: const Text("Are you sure dalete this message"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel"),
                                ),
                                FilledButton(
                                  onPressed: () async {
                                    await userService.messageService.deleteMessage(message.id, chatRoomId);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Yes"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: message.senderId == currentUser.uid ? Colors.blue[300] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: message.senderId == currentUser.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.text,
                                style: TextStyle(
                                  color: message.senderId == currentUser.uid ? Colors.white : Colors.black87,
                                ),
                              ),
                              const Gap(5),
                              Text(
                                "${message.dateTime.hour}:${message.dateTime.minute}",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: message.senderId == currentUser.uid ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Enter your message',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                isLoading
                    ? const CircularProgressIndicator()
                    : IconButton(
                        icon: const Icon(Icons.send),
                        color: Theme.of(context).primaryColor,
                        onPressed: () async {
                          if (textController.text.trim().isEmpty) return;

                          await userService.messageService.addMessage(
                            Message(
                              id: "",
                              senderId: currentUser.uid,
                              text: textController.text.trim(),
                              dateTime: DateTime.now(),
                            ),
                            chatRoomId,
                          );
                          textController.clear();
                          _scrollToBottom(); // Scroll to bottom when a new message is added
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
