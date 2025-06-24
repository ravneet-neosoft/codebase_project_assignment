import 'package:hive/hive.dart';
import 'package:codebase_project_assignment/feature/user_list/data/models/user_model.dart';

class HiveService {
  static const String _userListBox = "userListBox";
  static const String _userListKey = "cached_user_list";

  /// Save a paginated list of users into Hive (merges and de-duplicates)
  Future<void> saveUserPage(List<UserModel> pageUsers) async {
    final box = await Hive.openBox<List>(_userListBox);

    final existingUsers = await getUserList();

    // Merge and de-duplicate based on user.id
    final Map<int, UserModel> mergedMap = {
      for (var user in existingUsers) user.id: user,
      for (var user in pageUsers) user.id: user,
    };

    await box.put(_userListKey, mergedMap.values.toList());
  }

  /// Retrieve all cached users (paginated + merged)
  Future<List<UserModel>> getUserList() async {
    final box = await Hive.openBox<List>(_userListBox);
    final rawList = box.get(_userListKey, defaultValue: []);
    return rawList != null ? List<UserModel>.from(rawList) : [];
  }

  /// Get users for a specific page
  List<UserModel> getUsersForPage(List<UserModel> allUsers, int page) {
    int pageSize = 10;
    final start = (page - 1) * pageSize;
    final end = start + pageSize;
    return allUsers.sublist(
      start,
      end > allUsers.length ? allUsers.length : end,
    );
  }

  /// Clear cached user list
  Future<void> clearUserList() async {
    final box = await Hive.openBox<List>(_userListBox);
    await box.delete(_userListKey);
  }
}
