import 'package:admin_rental_app/config/theme.dart';
import 'package:admin_rental_app/screen/home_screen.dart';
import 'package:admin_rental_app/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAq4OVbT4EFf5liNP8qtaEINio-KqJ6wXw",
      appId: "1:50360599206:web:ce2063ad13ec49495d2a67",
      messagingSenderId: "50360599206",
      projectId: "rental-app-dcdbf",
      storageBucket: "rental-app-dcdbf.appspot.com",
    ),
  );
  runApp(const MyApp());
  // runApp(const ProviderScope(child: MyApp()));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Rental App Admin',
      theme: theme(),
      home: const AuthChecker(),
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
