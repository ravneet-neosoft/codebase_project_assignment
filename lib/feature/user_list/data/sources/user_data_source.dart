import 'dart:convert';
import 'package:codebase_project_assignment/feature/user_list/data/api/user_api_service.dart';
import 'package:codebase_project_assignment/feature/user_list/data/models/user_list_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserDataSource {
  Future<UserListResponseModel> fetchUsers({required int page});
}


class UserRemoteDataSourceImpl implements UserDataSource {
  final UserApiService apiService;

  UserRemoteDataSourceImpl(this.apiService);

  @override
  Future<UserListResponseModel> fetchUsers({required int page}) {
    return apiService.getUsers(page: page);
  }
}


class UserLocalDataSourceImpl implements UserDataSource {
  final SharedPreferences prefs;
  static const _cacheKey = 'cached_user_list';

  UserLocalDataSourceImpl(this.prefs);


  @override
  Future<UserListResponseModel> fetchUsers({required int page}) async {
    final jsonStr = prefs.getString(_cacheKey);
    if (jsonStr == null || jsonStr.isEmpty) {
      return UserListResponseModel(
        page: 1,
        perPage: 10,
        total: 0,
        totalPages: 0,
        users: [],
      );
    }
    final  decoded = jsonDecode(jsonStr);
    return UserListResponseModel.fromJson(decoded);
  }





 }
