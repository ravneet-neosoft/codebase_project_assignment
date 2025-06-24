import 'package:codebase_project_assignment/core/error/app_error.dart';
import 'package:codebase_project_assignment/core/service/network_connectivity.dart';
import 'package:codebase_project_assignment/core/utils/hive_services.dart';
import 'package:codebase_project_assignment/feature/user_list/data/mapper/user_extension.dart';
import 'package:codebase_project_assignment/feature/user_list/data/sources/user_data_source.dart';
import 'package:codebase_project_assignment/feature/user_list/domain/entities/user_entity.dart';
import 'package:codebase_project_assignment/feature/user_list/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource remote;
  final UserDataSource local;
  final HiveService hiveService;
  final NetworkConnectivityService network;

  UserRepositoryImpl(this.remote, this.local, this.hiveService, this.network);

  @override
  Future<List<UserEntity>> getUsers(int page) async {
    final isOnline = await network.isConnected;
    if (isOnline) {
      try {
        final response = await remote.fetchUsers(page: page);
        final userModels = response.users;
        if (page == 1) {
          hiveService.clearUserList();
        }
        hiveService.saveUserPage(userModels);
        return userModels.map((e) => e.toEntity()).toList();
      } catch (e) {
        throw AppError.server();
      }
    } else {
      try {
        final response = await local.fetchUsers(page: page);
        final userModels = response.users;

        return userModels.map((e) => e.toEntity()).toList();
      } catch (e) {
        throw AppError.cache();
      }
    }
  }
}
