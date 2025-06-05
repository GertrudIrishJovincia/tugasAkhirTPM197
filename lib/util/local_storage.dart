import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _keyLogin = 'is_logged_in';
  static const String _keyUsername = 'username';
  static const String _keyFavoriteIds = 'favorite_ids';

  // Simpan status login dan username
  static Future<void> login(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLogin, true);
    await prefs.setString(_keyUsername, username);
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLogin) ?? false;
  }

  static Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLogin);
    await prefs.remove(_keyUsername);
  }

  // **Fungsi baru untuk simpan user (username & password)**
  static Future<void> saveUser(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('password_$username', password);
  }

  // Fungsi untuk cek password user saat login
  static Future<bool> checkUserPassword(
    String username,
    String password,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPassword = prefs.getString('password_$username');
    return savedPassword == password;
  }

  // Ambil daftar favorite IDs (list string)
  static Future<List<String>?> getFavoriteIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyFavoriteIds);
  }

  // Simpan daftar favorite IDs (list string)
  static Future<void> setFavoriteIds(List<String> ids) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyFavoriteIds, ids);
  }

  // Tambah satu id ke favorite list
  static Future<void> addFavoriteId(String id) async {
    final ids = await getFavoriteIds() ?? [];
    if (!ids.contains(id)) {
      ids.add(id);
      await setFavoriteIds(ids);
    }
  }

  // Hapus satu id dari favorite list
  static Future<void> removeFavoriteId(String id) async {
    final ids = await getFavoriteIds() ?? [];
    if (ids.contains(id)) {
      ids.remove(id);
      await setFavoriteIds(ids);
    }
  }
}
