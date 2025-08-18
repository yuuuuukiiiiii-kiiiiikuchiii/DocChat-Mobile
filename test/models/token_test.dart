import 'package:flutter_test/flutter_test.dart';
import 'package:rag_faq_document/models/token/token.dart';


void main() {
  group('TokenModel', () {
    test('全フィールドを指定して初期化できる', () {
      final token = TokenModel(
        accessToken: 'access123',
        accessTokenExpiresAt: DateTime.parse('2025-06-17T00:00:00Z'),
        refreshToken: 'refresh456',
        refreshTokenExpiresAt: DateTime.parse('2025-07-17T00:00:00Z'),
        firstLaunchCompleted: true,
      );

      expect(token.accessToken, 'access123');
      expect(token.refreshToken, 'refresh456');
      expect(token.firstLaunchCompleted, true);
    });

    test('firstLaunchCompleted のデフォルト値は false', () {
      final token = TokenModel();
      expect(token.firstLaunchCompleted, false);
    });

    test('copyWith works as expected', () {
      final original = TokenModel(
        accessToken: 'old',
        firstLaunchCompleted: false,
      );

      final updated = original.copyWith(
        accessToken: 'new',
        firstLaunchCompleted: true,
      );

      expect(updated.accessToken, 'new');
      expect(updated.firstLaunchCompleted, true);
    });

    test('等価性テスト', () {
      final token1 = TokenModel(accessToken: 'a');
      final token2 = TokenModel(accessToken: 'a');
      expect(token1, equals(token2)); // == がオーバーライドされている
    });
  });
}
