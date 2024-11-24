import 'package:google_sign_in/google_sign_in.dart';

class GoogleService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<bool> logIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      return account != null; // Devuelve `true` si el inicio de sesión fue exitoso.
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
      return false; // Devuelve `false` si hubo algún error.
    }
  }
}
