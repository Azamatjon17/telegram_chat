import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:telegram_chat/services/AuthUserFairbases.dart';
import 'package:telegram_chat/views/screens/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  Authuserfairbases authuserfairbases = Authuserfairbases();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String? email;
  String? password;

  submit() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      formkey.currentState!.save();
      try {
        await authuserfairbases.login(email: email!, password: password!);
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  content: Text("Xato email kiritild"),
                ));
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.telegram,
                  size: 50,
                ),
                const Gap(20),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "email",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'email kriting';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    email = newValue;
                  },
                ),
                const Gap(20),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "password",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'password kriting';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    password = newValue;
                  },
                ),
                const Gap(20),
                InkWell(
                  onTap: submit,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              "Login",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
                const Gap(20),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegistPage()));
                  },
                  child: const Text("register page"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
