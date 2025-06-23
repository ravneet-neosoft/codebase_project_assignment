
import 'package:codebase_project_assignment/data/models/user_model.dart';
import 'package:codebase_project_assignment/domain/entities/user_entity.dart';

extension UserMapper on UserModel{
  UserEntity toEntity()=> UserEntity(id: id, email: email, firstName: firstName, lastName: lastName, avatar: avatar);

}