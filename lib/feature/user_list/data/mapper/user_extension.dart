import 'package:codebase_project_assignment/feature/user_list/data/models/user_model.dart';
import 'package:codebase_project_assignment/feature/user_list/domain/entities/user_entity.dart';

extension UserMapper on UserModel {
  UserEntity toEntity() => UserEntity(
    id: id,
    email: email,
    firstName: firstName,
    lastName: lastName,
    avatar: avatar,
  );
}
