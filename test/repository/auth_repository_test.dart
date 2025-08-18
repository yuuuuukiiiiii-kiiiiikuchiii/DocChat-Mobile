import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/repository/auth/auth_repository.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockDio mockDio;
  late AuthRepository repository;

  setUp(() {
    mockDio = MockDio();
    repository = AuthRepository(
      dio: mockDio,
      getDeviceInfoFn: () async => 'MockedDevice',
    );
  });

  group('signUp', () {
    test('successfully signs up', () async {
      when(mockDio.post('/users', data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/users'),
          statusCode: 200,
        ),
      );

      await repository.signUp(
        username: 'test',
        email: 'test@example.com',
        password: 'password',
      );
    });

    test('throws HttpErrorException on failure', () async {
      when(mockDio.post('/users', data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/users'),
          statusCode: 400,
          data: {'error': 'Bad Request'},
        ),
      );

      expect(
        () => repository.signUp(
          username: 'test',
          email: 'test@example.com',
          password: 'password',
        ),
        throwsA(isA<HttpErrorException>()),
      );
    });
  });

  group('login', () {
    test('returns UserResponse on success', () async {
      when(
        mockDio.post(
          '/users/login',
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/users/login'),
          statusCode: 200,
          data: {
            'access_token': 'access',
            'refresh_token': 'refresh',
            'access_token_expires_at': '2026-01-01T00:00:00Z',
            'refresh_token_expires_at': '2027-01-01T00:00:00Z',
            'user': {
              'id': 1,
              'username': 'user',
              'email': 'email@example.com',
              'created_at': '2024-01-01T00:00:00Z',
              'updated_at': '2024-01-01T00:00:00Z',
              'last_login_at': '2024-01-01T00:00:00Z',
            },
          },
        ),
      );

      final result = await repository.login(
        email: 'email@example.com',
        password: 'pass',
      );
      expect(result.accessToken, 'access');
    });

    test('login throws HttpErrorException on error', () async {
  when(mockDio.post(
    '/users/login',
    data: anyNamed('data'),
    options: anyNamed('options'),
  )).thenAnswer(
    (_) async => Response(
      requestOptions: RequestOptions(path: '/users/login'),
      statusCode: 400,
      data: {'error': 'Invalid credentials'},
    ),
  );

  expect(
    () => repository.login(email: 'wrong@example.com', password: 'wrongpass'),
    throwsA(isA<HttpErrorException>()),
  );
});

  });

  group('refreshAccessToken', () {
    test('returns new tokens on success', () async {
      when(
        mockDio.post(
          '/tokens/renew_access',
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/tokens/renew_access'),
          statusCode: 200,
          data: {
            'access_token': 'access',
            'refresh_token': 'refresh',
            'access_token_expires_at': '2026-01-01T00:00:00Z',
            'refresh_token_expires_at': '2027-01-01T00:00:00Z',
            'user': {
              'id': 1,
              'username': 'user',
              'email': 'email@example.com',
              'created_at': '2024-01-01T00:00:00Z',
              'updated_at': '2024-01-01T00:00:00Z',
              'last_login_at': '2024-01-01T00:00:00Z',
            },
          },
        ),
      );

      final result = await repository.refreshAccessToken('refreshToken');
      expect(result.accessToken, 'access');
    });

    test('throws HttpErrorException on 401', () async {
      when(
        mockDio.post(
          '/tokens/renew_access',
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/tokens/renew_access'),
          statusCode: 401,
        ),
      );

      expect(
        () => repository.refreshAccessToken('invalid'),
        throwsA(isA<HttpErrorException>()),
      );
    });
  });

  group('logout', () {
    test('logout success', () async {
      when(mockDio.post('/users/logout', data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/users/logout'),
          statusCode: 200,
        ),
      );

      await repository.logout(refreshToken: 'refresh');
    });

    test('logout throws HttpErrorException on error', () async {
  when(mockDio.post(
    '/users/logout',
    data: anyNamed('data'),
  )).thenAnswer(
    (_) async => Response(
      requestOptions: RequestOptions(path: '/users/logout'),
      statusCode: 400,
      data: {'error': 'Invalid refresh token'},
    ),
  );

  expect(
    () => repository.logout(refreshToken: 'invalid'),
    throwsA(isA<HttpErrorException>()),
  );
});

  });
}
