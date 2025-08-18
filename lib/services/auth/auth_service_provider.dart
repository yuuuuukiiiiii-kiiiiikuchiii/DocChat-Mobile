import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_faq_document/repository/auth/auth_repository_provider.dart';
import 'package:rag_faq_document/repository/local_storage/local_storage_provider.dart';
import 'package:rag_faq_document/services/auth/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service_provider.g.dart';

@riverpod
AuthService authService(Ref ref) {
  final storage = ref.watch(localStorageProvider);
  final repo = ref.watch(authRepositoryProvider);
  return AuthService(storage: storage, repo: repo);
}