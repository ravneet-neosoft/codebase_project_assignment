import 'package:codebase_project_assignment/domain/entities/user_entity.dart';
import 'package:codebase_project_assignment/domain/repositories/user_repository.dart';

class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  Future<List<UserEntity>> call(int page, {required bool isOnline}) async {
    return await repository.getUsers(page, isOnline: isOnline);
  }
}
