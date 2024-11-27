import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../services/google_services.dart'; // Importa el servicio de Google
import 'home.dart'; // Asegúrate de importar HomePage
import 'error_screen.dart'; // Importa ErrorScreen

class LoginScreen extends StatelessWidget {
  static final Logger _logger = Logger();

  const LoginScreen({super.key});

  Future<void> _handleLogin(BuildContext context) async {
    final bool isSuccess = await GoogleService.logIn();
    if (isSuccess) {
      _logger.i('Inicio de sesión exitoso');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      _logger.e('Falló el inicio de sesión');
      ErrorScreen.showErrorDialog(context, 'No se pudo iniciar sesión. Inténtalo nuevamente.');
    }
  }

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
            // Logo
            Image.asset(
              'assets/logo_utem.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 50),
            // Botón de inicio de sesión
            ElevatedButton.icon(
              onPressed: () => _handleLogin(context),
              icon: const Icon(Icons.login, color: Colors.white),
              label: const Text(
                'Iniciar sesión con Google',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
