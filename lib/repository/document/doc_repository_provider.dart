import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_faq_document/repository/dio/authenticated_dio_client_provider.dart';
import 'package:rag_faq_document/repository/document/doc_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'doc_repository_provider.g.dart';

@riverpod
DocRepository docRepository(Ref ref) {
  final client = ref.watch(authenticatedDioClientProvider);
  return DocRepository(client: client);
}
