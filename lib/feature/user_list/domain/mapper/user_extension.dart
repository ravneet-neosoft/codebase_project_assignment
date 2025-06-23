import 'package:codebase_project_assignment/feature/user_list/domain/entities/user_entity.dart';

extension UserEntityMapper on UserEntity {

  static UserEntity fromJson(Map<String, dynamic> json) => UserEntity(
    id: json['id'],
    email: json['email'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    avatar: json['avatar'],
  );
}
