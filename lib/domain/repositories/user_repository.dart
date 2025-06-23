import 'package:codebase_project_assignment/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<List<UserEntity>> getUsers(int page, {required bool isOnline});
  Future<List<UserEntity>> getCachedUsers();
}
