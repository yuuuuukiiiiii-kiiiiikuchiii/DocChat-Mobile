import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_faq_document/repository/chat/chat_repository_provider.dart';
import 'package:rag_faq_document/services/chat/chat_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_service_provider.g.dart';

@riverpod
ChatService chatService(Ref ref) {
  final repo = ref.watch(chatRepositoryProvider);
  return ChatService(repo: repo);
}