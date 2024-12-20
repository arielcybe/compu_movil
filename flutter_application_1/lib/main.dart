import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/CredentialRequest.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reportes UTEM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CredencialScreen(), // La app inicia con la pantalla de login
    );
  }
}
