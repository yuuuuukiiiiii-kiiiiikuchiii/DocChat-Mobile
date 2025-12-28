import 'package:rag_faq_document/models/profile/profile.dart';
import 'package:rag_faq_document/services/auth/auth_service_provider.dart';
import 'package:rag_faq_document/services/profile/profile_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_screen_provider.g.dart';

@Riverpod(keepAlive: true)
class ProfileScreen extends _$ProfileScreen {
  @override
  FutureOr<Profile> build() {
    return fetchProfile();
  }

  Future<Profile> fetchProfile() async {
    return await ref.read(profileServiceProvider).getProfile();
  }

  Future<void> reload() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return await ref.read(profileServiceProvider).getProfile();
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(authServiceProvider).logout();
      return Profile();
    });
  }
}
