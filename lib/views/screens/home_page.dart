import 'package:firebase_auth/firebase_auth.dart' as ath;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:telegram_chat/models/user.dart';
import 'package:telegram_chat/services/user_service.dart';
import 'package:telegram_chat/views/screens/chat_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final userServise = UserService();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home Page  ${ath.FirebaseAuth.instance.currentUser?.email}"),
      ),
      body: StreamBuilder(
        stream: userServise.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Malumot mavjud emas"),
            );
          }
          if (snapshot.data == null) {
            return const Center(
              child: Text("Malumot bo'sh"),
            );
          }

          final users = snapshot.data!.docs;
          return ListView.separated(
            separatorBuilder: (context, index) => const Gap(15),
            padding: const EdgeInsets.all(20),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final User user = User(
                id: users[index].id,
                name: users[index]['name'],
                userId: users[index]['user_id'],
              );

              return Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    boxShadow: const [
                      BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 10,
                        color: Colors.blue,
                      )
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(user: user),
                        ),
                      );
                    },
                    title: Text(
                      user.userId == ath.FirebaseAuth.instance.currentUser!.uid ? "me" : user.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    subtitle: Text(user.userId),
                  ));
            },
          );
        },
      ),
    );
  }
}
