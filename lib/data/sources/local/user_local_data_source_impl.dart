import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:codebase_project_assignment/data/models/user_model.dart';
import 'user_local_data_source.dart';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences prefs;
  static const _cacheKey = 'cached_user_list';

  UserLocalDataSourceImpl(this.prefs);

  @override
  Future<void> cacheUsers(List<UserModel> users) async {
    final encoded = jsonEncode(users.map((e) => e.toJson()).toList());
    await prefs.setString(_cacheKey, encoded);
  }

  @override
  Future<List<UserModel>> getCachedUsers() async {
    final jsonStr = prefs.getString(_cacheKey);
    if (jsonStr == null) return [];

    final decoded = jsonDecode(jsonStr) as List;
    return decoded.map((e) => UserModel.fromJson(e)).toList();
  }
}
