import 'dart:convert';
import 'package:codebase_project_assignment/core/error/app_error.dart';
import 'package:codebase_project_assignment/core/service/network_connectivity.dart';
import 'package:codebase_project_assignment/feature/user_list/data/mapper/user_extension.dart';
import 'package:codebase_project_assignment/feature/user_list/data/models/user_list_response_model.dart';
import 'package:codebase_project_assignment/feature/user_list/data/sources/user_data_source.dart';
import 'package:codebase_project_assignment/feature/user_list/domain/entities/user_entity.dart';
import 'package:codebase_project_assignment/feature/user_list/domain/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepositoryImpl implements UserRepository {
  final _cacheKey = 'cached_user_list';
  final UserDataSource remote;
  final UserDataSource local;
  final SharedPreferences sharedPreferences;
  final NetworkConnectivityService network;


  UserRepositoryImpl(
      this.remote,
      this.local,
      this.sharedPreferences,
      this.network
      );

  @override
  Future<List<UserEntity>> getUsers(int page) async {
    final isOnline = await network.isConnected;
    if (isOnline) {
      try {
        final response = await remote.fetchUsers(page: page);
        final userModels = response.users;


        // Cache only first page
        if (page == 1) {
          _cacheUsers(response);
        }

        return userModels.map((e) => e.toEntity()).toList();
      } catch (e) {
        throw AppError.server();
      }
    } else {
      if (page == 1) {
        try {
          final response = await local.fetchUsers(page: 1);
          final userModels = response.users;

          return userModels.map((e) => e.toEntity()).toList();
        } catch (e) {
          throw AppError.cache();
        }
      } else {
         return [];
      }
    }
  }


  Future<void> _cacheUsers(UserListResponseModel users) async {
    final encoded = jsonEncode(users.toJson());
    await sharedPreferences.setString(_cacheKey, encoded);
  }

}
