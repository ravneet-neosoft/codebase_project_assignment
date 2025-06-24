import 'package:codebase_project_assignment/core/utils/hive_services.dart';
import 'package:codebase_project_assignment/feature/user_list/data/api/user_api_service.dart';
import 'package:codebase_project_assignment/feature/user_list/data/models/user_list_response_model.dart';
import 'package:codebase_project_assignment/feature/user_list/data/models/user_model.dart';

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
  final HiveService hiveService;

  UserLocalDataSourceImpl(this.hiveService);

  @override
  Future<UserListResponseModel> fetchUsers({required int page}) async {
    final List<UserModel> allUsers = await hiveService.getUserList();
    List<UserModel>? paginatedUserList = hiveService.getUsersForPage(
      allUsers,
      page,
    );
    return UserListResponseModel(
      page: 1,
      perPage: 10,
      total: paginatedUserList.length,
      totalPages: 1,
      users: paginatedUserList,
    );
  }
}
