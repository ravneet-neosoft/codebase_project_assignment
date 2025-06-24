import 'package:codebase_project_assignment/generated/l10n.dart';
import 'package:codebase_project_assignment/core/error/app_error.dart';

class ErrorParser {
  ErrorParser._();

  static String parse(AppError error, S? s) {
    if (s == null) {
      return "";
    }
    switch (error.type) {
      case AppErrorType.network:
        return s.noInternet;
      case AppErrorType.cache:
        return s.noInternetAndCached;
      case AppErrorType.server:
        return s.serverError;
      case AppErrorType.timeout:
        return s.errorTimeout;
      case AppErrorType.unknown:
        return s.errorMsg;
    }
  }
}
