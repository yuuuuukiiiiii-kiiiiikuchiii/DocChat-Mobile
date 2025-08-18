import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rag_faq_document/utils/utils.dart';

import '../mocks/mocks.mocks.dart'; // ← 適切なパスに合わせて変更

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();


  group('DeviceService', () {
    late MockDeviceInfoWrapper mockWrapper;
    late DeviceService deviceService;

    setUp(() {
      mockWrapper = MockDeviceInfoWrapper();
      deviceService = DeviceService(mockWrapper);
    });

    test('should return device name from wrapper', () async {
      when(mockWrapper.getDeviceName()).thenAnswer((_) async => "Pixel 6");

      final result = await deviceService.getDeviceInfo();

      expect(result, "Pixel 6");
      verify(mockWrapper.getDeviceName()).called(1);
    });

    test('should return unknown if wrapper returns unknown', () async {
      when(mockWrapper.getDeviceName()).thenAnswer((_) async => "unknown");

      final result = await deviceService.getDeviceInfo();

      expect(result, "unknown");
    });
  });

  group('mapHttpErrorToUserMessage', () {
    test('returns email format error for status 400 with email in message', () {
      final result = mapHttpErrorToUserMessage("invalid email", 400);
      expect(result, "メールアドレスの形式が正しくありません。");
    });

    test(
      'returns duplicate email error for status 403 with duplicate in message',
      () {
        final result = mapHttpErrorToUserMessage("duplicate entry", 403);
        expect(result, "このメールアドレスはすでに登録されています。");
      },
    );

    test('returns auth error for status 401', () {
      final result = mapHttpErrorToUserMessage("unauthorized", 401);
      expect(result, "認証に失敗しました。もう一度ログインしてください。");
    });

    test('returns server error for status 500', () {
      final result = mapHttpErrorToUserMessage("internal error", 500);
      expect(result, "サーバーでエラーが発生しました。時間を置いて再試行してください。");
    });

    test('returns default error message for unknown cases', () {
      final result = mapHttpErrorToUserMessage("other error", 404);
      expect(result, "エラーが発生しました。もう一度お試しください。");
    });
  });
}
