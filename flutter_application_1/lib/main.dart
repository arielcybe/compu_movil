import 'package:flutter/material.dart';
import 'screens/login.dart'; // Ruta al archivo de Login

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const LoginScreen(), // La app inicia con la pantalla de login
    );
  }
}
