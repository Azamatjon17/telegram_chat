import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:telegram_chat/services/AuthUserFairbases.dart';

class RegistPage extends StatefulWidget {
  const RegistPage({super.key});

  @override
  State<RegistPage> createState() => _RegistPageState();
}

class _RegistPageState extends State<RegistPage> {
  bool isLoading = false;
  Authuserfairbases authuserfairbases = Authuserfairbases();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String? password2;
  String? email;
  String? password;
  String? name;

  submit() async {
    if (formkey.currentState!.validate()) {
      if (password == password2) {
        setState(() {
          isLoading = true;
        });
        formkey.currentState!.save();
        try {
          await authuserfairbases.register(email: email!, password: password!, name: name!);
          Navigator.pop(context);
        } catch (e) {
          showDialog(
              // ignore: use_build_context_synchronously
              context: context,
              builder: (context) => const AlertDialog(
                    content: Text("Xato email kiritild"),
                  ));
        }
        setState(() {
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("passwordlar bir biriga o'xshamyapti qayta kriting"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Center(
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
                      hintText: "name",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'ismingizni kriting';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      name = newValue;
                    },
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
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "varifaction password",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'password kriting';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      password2 = newValue;
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
                                "Register",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
                  const Gap(20),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("login page"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
