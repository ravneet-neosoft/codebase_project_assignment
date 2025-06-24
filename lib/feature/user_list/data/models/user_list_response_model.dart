import 'package:codebase_project_assignment/feature/user_list/data/models/user_model.dart';

class UserListResponseModel {
  final int page;
  final int perPage;
  final int total;
  final int totalPages;
  final List<UserModel> users;

  const UserListResponseModel({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.users,
  });

  factory UserListResponseModel.fromJson(Map<String, dynamic> json) {
    return UserListResponseModel(
      page: json['page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
      users:
          (json['data'] as List<dynamic>? ?? [])
              .map((e) => UserModel.fromJson(e))
              .toList(),
    );
  }
}
