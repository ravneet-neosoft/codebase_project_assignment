import 'dart:convert';

import 'package:codebase_project_assignment/core/error/app_error.dart';
import 'package:codebase_project_assignment/data/mapper/user_extension.dart';
import 'package:codebase_project_assignment/data/sources/local/user_local_data_source.dart';
import 'package:codebase_project_assignment/data/sources/remote/user_remote_data_source.dart';
import 'package:codebase_project_assignment/data/models/user_model.dart';
import 'package:codebase_project_assignment/domain/entities/user_entity.dart';
import 'package:codebase_project_assignment/domain/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;
  final UserLocalDataSource localDataSource;

  static const String cachedUserListKey = 'CACHED_USER_LIST';

  UserRepositoryImpl(
      this.remoteDataSource,
      this.sharedPreferences,
      this.localDataSource,
      );

  @override
  Future<List<UserEntity>> getUsers(int page, {required bool isOnline}) async {
    if (isOnline) {
      try {
        final response = await remoteDataSource.fetchUsers(page: page);
        final userModels = response.users;

        // Cache only first page
        if (page == 1) {
          await _cacheToLocalStorage(userModels);
        }

        return userModels.map((e) => e.toEntity()).toList();
      } catch (e) {
        throw AppError.server();
      }
    } else {
      if (page == 1) {
        final cached = _getCachedFromLocalStorage();
        if (cached != null) return cached;
        throw AppError.network();
      } else {
        throw AppError.network();
      }
    }
  }

  @override
  Future<List<UserEntity>> getCachedUsers() async {
    final models = await localDataSource.getCachedUsers();
    return models.map((e) => e.toEntity()).toList();
  }

  Future<void> _cacheToLocalStorage(List<UserModel> models) async {
    final jsonString = jsonEncode(models.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(cachedUserListKey, jsonString);
  }

  List<UserEntity>? _getCachedFromLocalStorage() {
    try {
      final cachedJson = sharedPreferences.getString(cachedUserListKey);
      if (cachedJson == null) return null;
      final decoded = jsonDecode(cachedJson);
      final users = (decoded as List)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return users.map((e) => e.toEntity()).toList();
    } catch (_) {
      return null;
    }
  }
}
