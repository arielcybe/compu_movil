import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class StorageService {
  static final Logger _logger = Logger();

  /// Borra todos los datos almacenados.
  static Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _logger.i("Todos los datos se han eliminado correctamente.");
    } catch (e) {
      _logger.e("Error al limpiar los datos del almacenamiento local: $e");
    }
  }

  /// Obtiene un valor almacenado por su clave.
  static Future<String?> getValue(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(key)) {
        final value = prefs.getString(key);
        _logger.i("Valor obtenido para la clave '$key': $value");
        return value;
      }
      _logger.w("La clave '$key' no existe en el almacenamiento.");
      return null;
    } catch (e) {
      _logger.e("Error al obtener el valor para la clave '$key': $e");
      return null;
    }
  }

  /// Guarda un valor con una clave específica.
  static Future<void> saveValue(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      _logger.i("Valor guardado para la clave '$key': $value");
    } catch (e) {
      _logger.e("Error al guardar el valor para la clave '$key': $e");
    }
  }

  /// Elimina un valor específico por su clave.
  static Future<void> removeValue(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(key)) {
        await prefs.remove(key);
        _logger.i("Clave '$key' eliminada del almacenamiento.");
      } else {
        _logger.w("No se encontró la clave '$key' para eliminar.");
      }
    } catch (e) {
      _logger.e("Error al eliminar la clave '$key': $e");
    }
  }

  /// Verifica si existe un valor para una clave específica.
  static Future<bool> containsKey(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final exists = prefs.containsKey(key);
      _logger.i("¿La clave '$key' existe?: $exists");
      return exists;
    } catch (e) {
      _logger.e("Error al verificar la clave '$key': $e");
      return false;
    }
  }
}
