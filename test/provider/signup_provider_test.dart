import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/pages/auth/signup/signup_provider.dart';
import 'package:rag_faq_document/services/auth/auth_service_provider.dart';


import '../mocks/mocks.mocks.dart';

void main() {
  late MockAuthService mockAuthService;
  late ProviderContainer container;

  setUp(() {
    mockAuthService = MockAuthService();
    container = ProviderContainer(overrides: [
      authServiceProvider.overrideWithValue(mockAuthService),
    ]);
  });

  tearDown(() {
    container.dispose();
  });

  test('signup success updates state to AsyncData', () async {
    when(mockAuthService.signup(
      username: anyNamed('username'),
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async {});

    final notifier = container.read(signupProvider.notifier);

    final future = notifier.signup(
      username: 'user',
      email: 'user@test.com',
      password: 'pass123',
    );

    expect(container.read(signupProvider).isLoading, true);

    await future;

    expect(container.read(signupProvider), const AsyncData<void>(null));
  });

  test('signup failure updates state to AsyncError', () async {
    when(mockAuthService.signup(
      username: anyNamed('username'),
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenThrow(CustomError.server(
      message: 'Signup failed',
      statusCode: 400,
      userMessage: 'サインアップに失敗しました',
    ));

    final notifier = container.read(signupProvider.notifier);

    final future = notifier.signup(
      username: 'user',
      email: 'user@test.com',
      password: 'pass123',
    );

    expect(container.read(signupProvider).isLoading, true);

    await future;

    final state = container.read(signupProvider);
    expect(state.hasError, true);
    expect(state.asError!.error, isA<CustomError>());
  });
}
