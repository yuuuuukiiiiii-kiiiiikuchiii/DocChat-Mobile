import 'package:rag_faq_document/services/auth/auth_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signin_provider.g.dart';

@riverpod
class Signin extends _$Signin {
  @override
  FutureOr<void> build() {
    print('🔧 signinProvider.build() called');
  }

  Future<void> signin({required String email, required String password}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref
          .read(authServiceProvider)
          .login(email: email, password: password);
    });
  }
}
