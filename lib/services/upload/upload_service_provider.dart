import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_faq_document/repository/upload/upload_repository_provider.dart';
import 'package:rag_faq_document/services/upload/upload_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_service_provider.g.dart';

@riverpod
UploadService uploadService(Ref ref) {
  final repo = ref.watch(uploadRepositoryProvider);
  return UploadService(repo: repo);
}
