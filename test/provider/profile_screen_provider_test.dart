import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/pages/profile/profile_screen_provider.dart';
import 'package:rag_faq_document/services/auth/auth_service_provider.dart';



import '../mocks/mocks.mocks.dart'; // MockAuthService がここにある前提

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

  test('logout success updates state to AsyncData', () async {
    // logout 成功時の挙動
    when(mockAuthService.logout()).thenAnswer((_) async {});

    final notifier = container.read(profileScreenProvider.notifier);

    final future = notifier.logout();

    expect(container.read(profileScreenProvider).isLoading, true);

    await future;

    expect(container.read(profileScreenProvider), const AsyncData<void>(null));
  });

  test('logout failure updates state to AsyncError', () async {
    // logout 失敗時の挙動
    when(mockAuthService.logout()).thenThrow(
      CustomError.server(
        message: 'Logout failed',
        statusCode: 500,
        userMessage: 'ログアウトに失敗しました',
      ),
    );

    final notifier = container.read(profileScreenProvider.notifier);

    final future = notifier.logout();

    expect(container.read(profileScreenProvider).isLoading, true);

    await future;

    final state = container.read(profileScreenProvider);
    expect(state.hasError, true);
    expect(state.asError!.error, isA<CustomError>());
  });
}
