import 'package:flutter_test/flutter_test.dart';
import 'package:rag_faq_document/exceptions/http_exception.dart';

void main() {
  group('HttpErrorException', () {
    test('can be instantiated with message and statusCode', () {
      final exception = HttpErrorException(
        message: 'エラーメッセージ',
        statusCode: 404,
      );

      expect(exception, isA<HttpErrorException>());
      expect(exception.message, 'エラーメッセージ');
      expect(exception.statusCode, 404);
    });

    test('toString() is readable (optional)', () {
      final exception = HttpErrorException(
        message: 'Not Found',
        statusCode: 404,
      );

      final str = exception.toString();
      expect(str, contains('HttpErrorException'));
      expect(str, contains('Not Found'));
      expect(str, contains('404'));
    });
  });
}
