

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rag_faq_document/pages/auth/signin/signin_provider.dart';
import 'package:rag_faq_document/services/auth/auth_service_provider.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';


void main() {
  late MockAuthService mockAuthService;
  late ProviderContainer container;

  setUp(() {
    mockAuthService = MockAuthService();
    container = ProviderContainer(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuthService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('signin success updates state to AsyncData', () async {
  when(mockAuthService.login(
    email: anyNamed('email'),
    password: anyNamed('password'),
  )).thenAnswer((_) async {});

  final notifier = container.read(signinProvider.notifier);

  final future = notifier.signin(email: 'test@test.com', password: '1234');

  
  expect(container.read(signinProvider).isLoading, true);

  await future;

  expect(container.read(signinProvider), const AsyncData<void>(null));
});


  test('signin failure updates state to AsyncError', () async {
  when(mockAuthService.login(
    email: anyNamed('email'),
    password: anyNamed('password'),
  )).thenThrow(Exception('login failed'));

  final notifier = container.read(signinProvider.notifier);

  final future = notifier.signin(email: 'test@test.com', password: '1234');

  // 🔧 修正: isLoadingを使う
  expect(container.read(signinProvider).isLoading, true);

  await future;

  final state = container.read(signinProvider);
  expect(state.hasError, true);
  expect(state.asError!.error, isA<Exception>());
});

}
