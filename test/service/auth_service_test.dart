import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/models/token/token.dart';
import 'package:rag_faq_document/models/auth/user_response.dart';
import 'package:rag_faq_document/services/auth/auth_service.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  late MockAuthRepository mockRepo;
  late MockLocalStorage mockStorage;
  late AuthService authService;

  setUp(() {
    mockRepo = MockAuthRepository();
    mockStorage = MockLocalStorage();
    authService = AuthService(storage: mockStorage, repo: mockRepo);
  });

  group('AuthService', () {
    test(
      'refreshAccessToken throws handled error on unknown exception',
      () async {
        when(
          mockRepo.refreshAccessToken('oldRefresh'),
        ).thenThrow(Exception('unknown'));

        expect(
          () => authService.refreshAccessToken('oldRefresh'),
          throwsA(isA<CustomError>()),
        );
      },
    );

    test('refreshAccessToken throws on non-401 HttpErrorException', () async {
      when(
        mockRepo.refreshAccessToken('oldRefresh'),
      ).thenThrow(HttpErrorException(message: 'server error', statusCode: 500));

      expect(
        () => authService.refreshAccessToken('oldRefresh'),
        throwsA(isA<CustomError>()),
      );
    });

    test('refreshAccessToken handles 401 and clears tokens', () async {
      when(
        mockRepo.refreshAccessToken('oldRefresh'),
      ).thenThrow(HttpErrorException(message: 'unauthorized', statusCode: 401));
      when(mockStorage.clearTokens()).thenAnswer((_) async {});

      expect(
        () => authService.refreshAccessToken('oldRefresh'),
        throwsA(isA<CustomError>()),
      );

      verify(mockStorage.clearTokens()).called(1);
    });

    test('logout throws CustomError.server on HttpErrorException', () async {
      when(mockStorage.getRefreshToken()).thenAnswer((_) async => 'token');
      when(
        mockRepo.logout(refreshToken: 'token'),
      ).thenThrow(HttpErrorException(message: 'error', statusCode: 403));

      expect(() => authService.logout(), throwsA(isA<CustomError>()));
    });

    test('logout does nothing if refreshToken is null', () async {
      when(mockStorage.getRefreshToken()).thenAnswer((_) async => null);

      await authService.logout();

      verifyNever(mockRepo.logout(refreshToken: anyNamed('refreshToken')));
      verifyNever(mockStorage.clearTokens());
    });

    test('login throws handled error on unknown exception', () async {
      when(
        mockRepo.login(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(Exception('Unexpected'));

      expect(
        () => authService.login(email: 'x@x.com', password: 'x'),
        throwsA(isA<CustomError>()),
      );
    });

    test('login throws CustomError.server on HttpErrorException', () async {
      when(
        mockRepo.login(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(HttpErrorException(message: 'Unauthorized', statusCode: 401));

      expect(
        () => authService.login(email: 'user@test.com', password: '1234'),
        throwsA(isA<CustomError>()),
      );
    });

    test('signup success', () async {
      when(
        mockRepo.signUp(
          username: anyNamed('username'),
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async {});

      await authService.signup(
        username: 'name',
        email: 'a@a.com',
        password: 'pass',
      );

      verify(
        mockRepo.signUp(username: 'name', email: 'a@a.com', password: 'pass'),
      ).called(1);
    });

    test('signup throws CustomError.server on HttpErrorException', () async {
      when(
        mockRepo.signUp(
          username: anyNamed('username'),
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(HttpErrorException(message: 'Bad request', statusCode: 400));

      expect(
        () => authService.signup(
          username: 'x',
          email: 'x@x.com',
          password: '123',
        ),
        throwsA(isA<CustomError>()),
      );
    });

    test('login success saves tokens and user', () async {
      final now = DateTime.now();
      final user = UserModel(
        id: 1,
        username: 'test',
        email: 'test@test.com',
        createdAt: now.toIso8601String(),
        updatedAt: now.toIso8601String(),
        lastLoginAt: now.toIso8601String(),
      );

      final userResponse = UserResponse(
        accessToken: 'access',
        accessTokenExpiresAt: now.toIso8601String(),
        refreshToken: 'refresh',
        refreshTokenExpiresAt: now.toIso8601String(),
        user: user,
      );

      when(
        mockRepo.login(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => userResponse);

      await authService.login(email: 'e@e.com', password: '1234');

      verify(
        mockStorage.saveTokens(
          accessToken: 'access',
          accessTokenExpiresAt: anyNamed('accessTokenExpiresAt'),
          refreshToken: 'refresh',
          refreshTokenExpiresAt: anyNamed('refreshTokenExpiresAt'),
        ),
      ).called(1);
    });

    test('logout success when refreshToken exists', () async {
      when(
        mockStorage.getRefreshToken(),
      ).thenAnswer((_) async => 'refresh_token');

      when(
        mockRepo.logout(refreshToken: 'refresh_token'),
      ).thenAnswer((_) async {});
      when(mockStorage.clearTokens()).thenAnswer((_) async {});

      await authService.logout();

      verify(mockRepo.logout(refreshToken: 'refresh_token')).called(1);
      verify(mockStorage.clearTokens()).called(1);
    });

    test('refreshAccessToken success', () async {
      final now = DateTime.now();
      final user = UserModel(
        id: 1,
        username: 'test',
        email: 'test@test.com',
        createdAt: now.toIso8601String(),
        updatedAt: now.toIso8601String(),
        lastLoginAt: now.toIso8601String(),
      );

      final userResponse = UserResponse(
        accessToken: 'access',
        accessTokenExpiresAt: now.toIso8601String(),
        refreshToken: 'refresh',
        refreshTokenExpiresAt: now.toIso8601String(),
        user: user,
      );

      final tokenModel = TokenModel(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessTokenExpiresAt: DateTime.now(),
        refreshTokenExpiresAt: DateTime.now(),
        firstLaunchCompleted: true,
      );

      when(
        mockRepo.refreshAccessToken('oldRefresh'),
      ).thenAnswer((_) async => userResponse);
      when(
        mockStorage.saveTokens(
          accessToken: anyNamed('accessToken'),
          accessTokenExpiresAt: anyNamed('accessTokenExpiresAt'),
          refreshToken: anyNamed('refreshToken'),
          refreshTokenExpiresAt: anyNamed('refreshTokenExpiresAt'),
        ),
      ).thenAnswer((_) async {});

      when(mockStorage.getToken()).thenAnswer((_) async => tokenModel);

      final result = await authService.refreshAccessToken('oldRefresh');
      expect(result.accessToken, equals('access'));
    });
  });
}
