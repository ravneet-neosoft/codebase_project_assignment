import 'package:codebase_project_assignment/core/error/app_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  static Dio createDioClient() {
    final baseUrl = dotenv.env['API_BASE_URL'];
    final apiKey = dotenv.env['API_KEY'];

    if (baseUrl == null || apiKey == null) {
      throw AppError.unknown("Something went wrong. Please try again later.");
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'x-api-key': apiKey, 'Accept': 'application/json'},
        responseType: ResponseType.json,
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: false,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) {
          handler.next(e);
        },
      ),
    );

    return dio;
  }
}
