class HttpErrorException implements Exception {
  String message;
  int statusCode;
  HttpErrorException({required this.message, required this.statusCode});
  @override
  String toString() => 'HttpErrorException($statusCode): $message';
}
