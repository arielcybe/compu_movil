import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleService {
  static final Logger _logger = Logger();
  static final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  /// Inicia sesión con Google y valida el dominio del correo
  static Future<bool> logIn() async {
    bool ok = false;
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        // Verificar el dominio del correo
        if (!account.email.endsWith('@utem.cl')) {
          _logger.e('Dominio no permitido: ${account.email}');
          await _googleSignIn.signOut();
          return false; // Retorna falso si el dominio no es válido
        }

        // Obtiene la autenticación
        GoogleSignInAuthentication auth = await account.authentication;
        String idToken = auth.idToken ?? '';
        String accessToken = auth.accessToken ?? '';

        // Log de información para depuración
        _logger.d('Token: $idToken');
        _logger.d('Access Token: $accessToken');

        // Valida que los tokens no estén vacíos
        ok = idToken.isNotEmpty && accessToken.isNotEmpty;

        if (ok) {
          // Guarda la información en SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('idToken', idToken);
          await prefs.setString('accessToken', accessToken);
          await prefs.setString('email', account.email);
          await prefs.setString('name', account.displayName ?? '');
          await prefs.setString('image', account.photoUrl ?? '');
        }
      }
    } catch (e) {
      // Log del error
      _logger.e('Error al iniciar sesión con Google: $e');
    }
    return ok;
  }

  /// Cierra sesión con Google y limpia los datos guardados
  static Future<void> logOut() async {
    try {
      // Cerrar sesión en Google
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect();

      // Limpiar datos almacenados localmente
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _logger.i('Sesión cerrada y datos limpiados');
    } catch (e) {
      _logger.e('Error al cerrar sesión: $e');
    }
  }

  /// Comprueba si el usuario ya inició sesión previamente
  static Future<bool> isLoggedIn() async {
    try {
      final account = _googleSignIn.currentUser;
      return account != null;
    } catch (e) {
      _logger.e('Error al verificar el inicio de sesión: $e');
      return false;
    }
  }
}
