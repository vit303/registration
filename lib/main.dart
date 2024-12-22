import 'package:flutter/material.dart';
import 'package:registration/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 180, 149, 235)),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}

