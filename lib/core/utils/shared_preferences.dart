import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _cachedUserListKey = 'cached_user_list';

  Future<void> cacheUserList(List<Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(users);
    await prefs.setString(_cachedUserListKey, encoded);
  }

  Future<List<Map<String, dynamic>>> getCachedUserList() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_cachedUserListKey);
    if (data != null) {
      final decoded = jsonDecode(data) as List;
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<void> clearUserCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cachedUserListKey);
  }
}
