import 'package:flutter/material.dart';
import 'error_screen.dart';
import 'home.dart';
import 'Login.dart';
import 'package:flutter_application_1/services/process.dart';

class CredencialScreen extends StatefulWidget {
  const CredencialScreen({super.key});

  @override
  _CredencialScreenState createState() => _CredencialScreenState();
}

class _CredencialScreenState extends State<CredencialScreen> {
  String credencial = ''; // La variable se define aquí
  late bool real;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6400ab), Color(0xFFbbd80d)],
            stops: [0.2, 0.9],
            begin: Alignment(-2.5, 1),
            end: Alignment(3, 1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FractionallySizedBox(
              widthFactor: 0.9,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Ingrese el token de la API',
                  filled: true,
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  alignLabelWithHint: true,
                ),
                onChanged: (value) {
                  setState(() {
                    credencial = value; // Aquí se actualiza el estado
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              label: const Text(
                'Ingresar',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ), onPressed: () async {
                real = await credentialIsReal(credential: credencial);
                if (real) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                } else {
                  ErrorScreen.showErrorDialog(context, 'No se pudo ingresar, la credencial ingresada no es valida.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
