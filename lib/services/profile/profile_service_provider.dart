import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_faq_document/repository/profile/profile_repository_provider.dart';
import 'package:rag_faq_document/services/profile/profile_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_service_provider.g.dart';

@riverpod
ProfileService profileService(Ref ref) {
  final repo = ref.read(profileRepositoryProvider);
  return ProfileService(repo: repo);
}
