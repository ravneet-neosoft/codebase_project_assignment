import 'package:codebase_project_assignment/feature/user_list/domain/entities/user_entity.dart';
import 'package:codebase_project_assignment/feature/user_list/domain/repositories/user_repository.dart';

class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  Future<List<UserEntity>> call(int page) async {
    return await repository.getUsers(page);
  }
}
