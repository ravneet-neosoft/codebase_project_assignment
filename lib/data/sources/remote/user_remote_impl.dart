import 'package:codebase_project_assignment/data/api/user_api_service.dart';
import 'package:codebase_project_assignment/data/models/user_list_response_model.dart';
import 'package:codebase_project_assignment/data/sources/remote/user_remote_data_source.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final UserApiService apiService;

  UserRemoteDataSourceImpl(this.apiService);

  @override
  Future<UserListResponseModel> fetchUsers({required int page}) {
    return apiService.getUsers(page: page);
  }
}