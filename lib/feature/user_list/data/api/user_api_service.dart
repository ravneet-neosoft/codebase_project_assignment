import 'package:codebase_project_assignment/feature/user_list/data/models/user_list_response_model.dart';

abstract class UserApiService {
  Future<UserListResponseModel> getUsers({required int page});
}
