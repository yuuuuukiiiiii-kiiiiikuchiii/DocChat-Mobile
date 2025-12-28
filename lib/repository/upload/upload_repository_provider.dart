import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_faq_document/repository/dio/authenticated_dio_client_provider.dart';
import 'package:rag_faq_document/repository/upload/upload_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_repository_provider.g.dart';

@riverpod
UploadRepository uploadRepository(Ref ref) {
  final client = ref.watch(authenticatedDioClientProvider);

  // 別のDioインスタンスを使う！Interceptorが付いてない
  final refreshDio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );
  return UploadRepository(client: client, dio: refreshDio, ref: ref);
}
