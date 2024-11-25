import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleService {
  static final Logger _logger = Logger();
  static final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  static Future<bool> logIn() async {
    bool ok = false;
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
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
          SharedPreferences.getInstance().then((current) {
            current.setString('idToken', idToken);
            current.setString('accessToken', accessToken);
            current.setString('email', account.email);
            current.setString('name', account.displayName ?? '');
            current.setString('image', account.photoUrl ?? '');
          });
        }
      }
    } catch (e) {
      // Log del error
      _logger.e('Error al iniciar sesión con Google: $e');
    }
    return ok; // Retorna true si todo fue exitoso, false en caso contrario
  }
}

