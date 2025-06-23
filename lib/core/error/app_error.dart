enum AppErrorType {
  network,
  cache,
  server,
  timeout,
  unauthorized,
  unknown,
}


class AppError {
  final AppErrorType type;
  final String message;

  const AppError({
    required this.type,
    required this.message,
  });

  @override
  String toString() => message;

  // Factory constructor for errors
  factory AppError.network([String? message]) {
    return AppError(
      type: AppErrorType.network,
      message: message ?? "No Internet Connection",
    );
  }

  factory AppError.cache([String? message]) {
    return AppError(
      type: AppErrorType.cache,
      message: message ?? "Cache Error",
    );
  }

  factory AppError.server([String? message]) {
    return AppError(
      type: AppErrorType.server,
      message: message ?? "Server Error",
    );
  }

  factory AppError.timeout([String? message]) {
    return AppError(
      type: AppErrorType.timeout,
      message: message ?? "Request Timed Out",
    );
  }

  factory AppError.unauthorized([String? message]) {
    return AppError(
      type: AppErrorType.unauthorized,
      message: message ?? "Unauthorized Access",
    );
  }

  factory AppError.unknown([String? message]) {
    return AppError(
      type: AppErrorType.unknown,
      message: message ?? "Something went wrong",
    );
  }
}
