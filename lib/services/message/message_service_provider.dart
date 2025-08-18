import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_faq_document/repository/message/message_repository_provider.dart';
import 'package:rag_faq_document/services/message/message_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_service_provider.g.dart';

@riverpod
MessageService messageService(Ref ref) {
  final repo = ref.read(messageRepositoryProvider);
  return MessageService(repo: repo);
}
