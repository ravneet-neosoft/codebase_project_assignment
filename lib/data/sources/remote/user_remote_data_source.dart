import 'package:codebase_project_assignment/data/models/user_list_response_model.dart';

abstract class UserRemoteDataSource {
  Future<UserListResponseModel> fetchUsers({required int page});
}

