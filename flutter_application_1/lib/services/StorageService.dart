import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final Logger _logger = Logger();

  static Future<String> getValue(String key) async {
    String value = '';
    await SharedPreferences.getInstance().then((instance) {
      if (instance.containsKey(key)) {
        value = instance.getString(key) ?? '';
      }
    });
    return value;
  }
}