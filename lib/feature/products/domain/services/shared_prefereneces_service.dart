import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenecesService {
  static SharedPreferences? _pref;

  static Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static void setString({required String key, required dynamic value}) {
    _pref?.setString(key, value);
  }

  static String? getString({required String key}) {
    return _pref?.getString(key);
  }

  static void removeString({required String key}) {
    _pref!.remove(key);
  }

  static void isLoggedIn({required String key, bool? value}) {
    _pref!.setBool(key, value!);
  }
}
