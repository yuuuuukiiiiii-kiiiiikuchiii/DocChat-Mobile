import 'package:rag_faq_document/services/auth/auth_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'password_reset_provider.g.dart';

@riverpod
class PasswordReset extends _$PasswordReset {
  @override
  FutureOr<void> build() {
  }

  Future<void> passwordReset(String email) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref
          .read(authServiceProvider)
          .passwordReset(email);
    });
  }
}
