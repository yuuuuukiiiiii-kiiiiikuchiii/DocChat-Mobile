


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_faq_document/repository/document/doc_repository_provider.dart';
import 'package:rag_faq_document/services/document/doc_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'doc_service_provider.g.dart';

@riverpod
DocService docService(Ref ref) {
  final repo = ref.read(docRepositoryProvider);
  return DocService(repo: repo);
}