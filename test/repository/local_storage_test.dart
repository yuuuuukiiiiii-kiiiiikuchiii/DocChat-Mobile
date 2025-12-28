import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rag_faq_document/repository/local_storage/local_storage.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  group('LocalStorage', () {
    test('初期状態: access は null', () {
      final mockSecure = MockFlutterSecureStorage();
      final storage = LocalStorage(secure: mockSecure);

      expect(storage.access, isNull);
      verifyZeroInteractions(mockSecure);
    });

    test('setAccess でメモリ上の access が更新される', () async {
      final mockSecure = MockFlutterSecureStorage();
      final storage = LocalStorage(secure: mockSecure);

      await storage.setAccess('ACCESS_123');
      expect(storage.access, 'ACCESS_123');
      verifyZeroInteractions(mockSecure); // セキュアストレージは触らない
    });

    test('saveRefresh → write(key: refresh_token, value: ...)', () async {
      final mockSecure = MockFlutterSecureStorage();
      final storage = LocalStorage(secure: mockSecure);

      when(
        mockSecure.write(key: anyNamed('key'), value: anyNamed('value')),
      ).thenAnswer((_) async {});

      await storage.saveRefresh('REFRESH_ABC');

      verify(
        mockSecure.write(key: 'refresh_token', value: 'REFRESH_ABC'),
      ).called(1);
      verifyNoMoreInteractions(mockSecure);
    });

    test('loadRefresh → read(key: refresh_token) の結果を返す', () async {
      final mockSecure = MockFlutterSecureStorage();
      final storage = LocalStorage(secure: mockSecure);

      when(
        mockSecure.read(key: anyNamed('key')),
      ).thenAnswer((_) async => 'REFRESH_ABC');

      final v = await storage.loadRefresh();
      expect(v, 'REFRESH_ABC');

      verify(mockSecure.read(key: 'refresh_token')).called(1);
      verifyNoMoreInteractions(mockSecure);
    });

    test('clear は access を null にし、refresh_token を削除する', () async {
      final mockSecure = MockFlutterSecureStorage();
      final storage = LocalStorage(secure: mockSecure);

      // 先に access をセット
      await storage.setAccess('ACCESS_123');
      expect(storage.access, 'ACCESS_123');

      when(mockSecure.delete(key: anyNamed('key'))).thenAnswer((_) async {});

      await storage.clear();

      expect(storage.access, isNull);
      verify(mockSecure.delete(key: 'refresh_token')).called(1);
      verifyNoMoreInteractions(mockSecure);
    });
  });
}
