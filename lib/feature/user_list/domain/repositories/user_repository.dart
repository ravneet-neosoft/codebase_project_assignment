import 'package:codebase_project_assignment/feature/user_list/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<List<UserEntity>> getUsers(int page,);
}
