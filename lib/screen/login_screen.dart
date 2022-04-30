import 'package:admin_rental_app/config/palette.dart';
import 'package:admin_rental_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _continuousValidation = false;
  String _messageToDisplay = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  color: primaryLightColor,
                  borderRadius: BorderRadius.circular(20), // radius
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/appicon.png',
                        height: 150,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                          key: _formKey,
                          autovalidateMode: _continuousValidation
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: _email,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  labelText: 'อีเมล',
                                ),
                                autocorrect: false,
                                keyboardType: TextInputType.emailAddress,
                                validator: (input) {
                                  if (input!.isEmpty ||
                                      !RegExp(r"""^(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])""")
                                          .hasMatch(input)) {
                                    return 'รูปแบบอีเมลไม่ถูกต้อง';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _password,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock),
                                  labelText: 'รหัสผ่าน',
                                ),
                                autocorrect: false,
                                obscureText: true,
                                validator: (input) {
                                  if (input!.isEmpty) return 'โปรดใส่รหัสผ่าน';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: primaryColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                ),
                                onPressed: () async {
                                  if (!_formKey.currentState!.validate()) {
                                    setState(() {
                                      _continuousValidation = true;
                                    });
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) => const Center(
                                            child:
                                                CircularProgressIndicator()));
                                    try {
                                      await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                              email: _email.text,
                                              password: _password.text);
                                    } on FirebaseAuthException catch (e) {
                                      switch (e.code) {
                                        case 'invalid-email':
                                          _messageToDisplay = 'อีเมลไม่ถูกต้อง';
                                          break;
                                        case 'user-disabled':
                                          _messageToDisplay =
                                              'บัญชีถูกระงับการใช้งาน กรุณาติดต่อผู้ดูแลระบบ';
                                          break;
                                        case 'user-not-found':
                                          _messageToDisplay =
                                              'ไม่พบบัญชีผู้ใช้งาน';
                                          break;
                                        case 'wrong-password':
                                          _messageToDisplay =
                                              'รหัสผ่านไม่ถูกต้อง';
                                          break;
                                        default:
                                          _messageToDisplay = 'ไม่ทราบสาเหตุ';
                                          break;
                                      }
                                      await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('เกิดข้อผิดพลาด'),
                                          content: Text(_messageToDisplay),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("ตกลง"))
                                          ],
                                        ),
                                      );
                                    }
                                    navigatorKey.currentState!
                                        .popUntil((route) => route.isFirst);
                                  }
                                },
                                child: const Text(
                                  'เข้าสู่ระบบ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
