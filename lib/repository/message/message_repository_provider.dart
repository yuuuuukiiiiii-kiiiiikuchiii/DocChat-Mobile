import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_faq_document/repository/dio/authenticated_dio_client_provider.dart';
import 'package:rag_faq_document/repository/message/message_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_repository_provider.g.dart';

@riverpod
MessageRepository messageRepository(Ref ref) {
  final client = ref.watch(authenticatedDioClientProvider);
  return MessageRepository(client: client);
}
