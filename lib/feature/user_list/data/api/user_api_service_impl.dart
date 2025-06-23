import 'package:dio/dio.dart';
import 'package:codebase_project_assignment/feature/user_list/data/api/user_api_service.dart';
import 'package:codebase_project_assignment/feature/user_list/data/models/user_list_response_model.dart';

class UserApiServiceImpl implements UserApiService {
  final Dio dio;

  UserApiServiceImpl(this.dio);

  @override
  Future<UserListResponseModel> getUsers({required int page}) async {
    try {
      final response = await dio.get(
        '/users',
        queryParameters: {'per_page': 10, 'page': page},
      );
      return UserListResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('User API Error: ${e.message}');
    }
  }
}
