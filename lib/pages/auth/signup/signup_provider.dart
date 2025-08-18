import 'package:rag_faq_document/services/auth/auth_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup_provider.g.dart';

@riverpod
class Signup extends _$Signup {
  @override
  FutureOr<void> build() {
    print('🔧 signupProvider.build() called');
  }

  Future<void> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading<void>();

    state = await AsyncValue.guard(() async {
      await ref
          .read(authServiceProvider)
          .signup(username: username, email: email, password: password);
    });
  }
}
