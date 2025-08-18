import 'package:rag_faq_document/repository/chat/chat_repository.dart';
import 'package:rag_faq_document/repository/dio/authenticated_dio_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repository_provider.g.dart';

@riverpod
ChatRepository chatRepository(Ref ref) {
  final client = ref.watch(authenticatedDioClientProvider);
  return ChatRepository(client: client);
}
