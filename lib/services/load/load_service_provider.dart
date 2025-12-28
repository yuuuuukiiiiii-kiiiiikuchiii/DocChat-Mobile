import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_faq_document/repository/load/load_repository_provider.dart';
import 'package:rag_faq_document/services/load/load_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'load_service_provider.g.dart';

@riverpod
LoadService loadService(Ref ref) {
  final repo = ref.watch(loadRepositoryProvider);
  return LoadService(repo: repo);
}
