import 'package:codebase_project_assignment/data/models/user_list_response_model.dart';

abstract class UserApiService {
  Future<UserListResponseModel> getUsers({required int page});
}
