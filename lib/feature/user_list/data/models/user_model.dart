import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart'; // Required for both Hive + JSON

@HiveType(typeId: 0)
@JsonSerializable()
class UserModel {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final int id;

  @HiveField(2)
  @JsonKey(name: 'first_name')
  final String firstName;

  @HiveField(3)
  @JsonKey(name: 'last_name')
  final String lastName;

  @HiveField(4)
  final String avatar;

  UserModel({
    required this.email,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
