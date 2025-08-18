import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:rag_faq_document/repository/dio/authenticated_dio_client.dart';
import '../mocks/mock_http_client_adapter.dart';
import '../mocks/mocks.mocks.dart';

void main() {
  late MockLocalStorage mockStorage;
  late AuthenticatedDioClient client;
  late bool unauthorizedCalled;

  setUp(() {
    mockStorage = MockLocalStorage();
    unauthorizedCalled = false;

    client = AuthenticatedDioClient(
      storage: mockStorage,
      baseUrl: 'https://example.com',
      onUnauthorized: () {
        unauthorizedCalled = true;
      },
      deviceInfoGetter: () async => 'Mocked-Device',
    );
  });


  test('does not call onUnauthorized on non-401 errors', () async {
  when(mockStorage.getAccessToken()).thenAnswer((_) async => 'token');

  client.dio.httpClientAdapter = MockHttpClientAdapter(
    onFetch: (_) async => ResponseBody.fromString('Server error', 500),
  );

  try {
    await client.dio.get('/server-error');
  } catch (_) {}

  expect(unauthorizedCalled, isFalse);
});


  test('adds Authorization header to requests', () async {
  when(mockStorage.getAccessToken()).thenAnswer((_) async => 'dummy_token');

  // HTTP Adapter モックをセット
  client.dio.httpClientAdapter = MockHttpClientAdapter(
    onFetch: (options) async {
      expect(options.headers['Authorization'], 'Bearer dummy_token');
      return ResponseBody.fromString('OK', 200);
    },
  );

  await client.dio.get('/test');
});

test('does not call refresh on 200 response', () async {
  when(mockStorage.getAccessToken()).thenAnswer((_) async => 'valid_token');

  client.dio.httpClientAdapter = MockHttpClientAdapter(
    onFetch: (options) async {
      return ResponseBody.fromString('OK', 200);
    },
  );

  final response = await client.dio.get('/normal');
  expect(response.statusCode, 200);
  expect(unauthorizedCalled, isFalse);
});



  test('refreshes token and retries request on 401', () async {
    when(mockStorage.getAccessToken()).thenAnswer((_) async => 'expired_token');
    when(mockStorage.getRefreshToken()).thenAnswer((_) async => 'valid_refresh_token');

    // モックで新しいトークンを返す準備
    when(mockStorage.saveTokens(
      accessToken: anyNamed('accessToken'),
      accessTokenExpiresAt: anyNamed('accessTokenExpiresAt'),
      refreshToken: anyNamed('refreshToken'),
      refreshTokenExpiresAt: anyNamed('refreshTokenExpiresAt'),
    )).thenAnswer((_) async => {});

    // モックHTTP Adapter
    client.dio.httpClientAdapter = MockHttpClientAdapter(
      onFetch: (RequestOptions options) async {
        if (options.path.contains("/tokens/renew_access")) {
          final fakeResponse = jsonEncode({
            "access_token": "new_access_token",
            "access_token_expires_at": "2026-01-01T00:00:00Z",
            "refresh_token": "new_refresh_token",
            "refresh_token_expires_at": "2027-01-01T00:00:00Z",
            "user": {
              "id": 1,
              "username": "user",
              "email": "email@example.com",
              "created_at": "2024-01-01T00:00:00Z",
              "updated_at": "2024-01-01T00:00:00Z",
              "last_login_at": "2024-01-01T00:00:00Z"
            }
          });

          return ResponseBody.fromString(
            fakeResponse,
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType]
            },
          );
        } else {
          return ResponseBody.fromString(
            'Success',
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType]
            },
          );
        }
      },
    );

    final response = await client.dio.post("/tokens/renew_access", data: {
      "refresh_token": "valid_refresh_token",
    });

    expect(response.statusCode, 200);
    expect(unauthorizedCalled, isFalse);
  });
}
