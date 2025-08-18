import 'package:flutter_test/flutter_test.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';



void main() {
  group('CustomError', () {
    test('server error retains correct fields', () {
      final error = CustomError.server(
        statusCode: 404,
        message: 'Not Found',
        userMessage: 'ページが見つかりません',
      );

      expect(error, isA<ServerError>());
      expect((error as ServerError).statusCode, 404);
      expect(error.message, 'Not Found');
      expect(error.userMessage, 'ページが見つかりません');
    });

    test('timeout error has default userMessage', () {
      final error = CustomError.timeout(message: 'Timeout occurred');

      expect(error, isA<TimeoutError>());
      expect(error.message, 'Timeout occurred');
      expect(error.userMessage,
          'リクエストがタイムアウトしました。時間を置いて再試行してください。');
    });

    test('network error has default userMessage', () {
      final error = CustomError.network(message: 'No internet');

      expect(error, isA<NetworkError>());
      expect(error.message, 'No internet');
      expect(error.userMessage, 'ネットワークに接続できません。接続を確認してください。');
    });

    test('unknown error has default userMessage', () {
      final error = CustomError.unknown(message: 'Unexpected');

      expect(error, isA<UnknownError>());
      expect(error.message, 'Unexpected');
      expect(error.userMessage, '不明なエラーが発生しました。');
    });

  });
}
