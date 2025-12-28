class HttpErrorException implements Exception {
  final String message;
  final int statusCode;
  final int? retryAfterSeconds; // 429用に追加（任意）

  HttpErrorException({
    required this.message,
    required this.statusCode,
    this.retryAfterSeconds,
  });

  @override
  String toString() {
    if (retryAfterSeconds != null) {
      return 'HttpErrorException($statusCode): $message（$retryAfterSeconds 秒後に再試行）';
    }
    return 'HttpErrorException($statusCode): $message';
  }
}

