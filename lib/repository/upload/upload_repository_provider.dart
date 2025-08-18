import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_faq_document/repository/dio/authenticated_dio_client_provider.dart';
import 'package:rag_faq_document/repository/local_storage/local_storage_provider.dart';
import 'package:rag_faq_document/repository/upload/upload_repository.dart';
import 'package:rag_faq_document/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_repository_provider.g.dart';

@riverpod
UploadRepository uploadRepository(Ref ref) {
  final client = ref.watch(authenticatedDioClientProvider);
  final baseUrl = dotenv.env["BASEURL"];
  final storage = ref.watch(localStorageProvider);
  final getDeviceInfoFn = DeviceInfoWrapperImpl().getDeviceName;

  // 別のDioインスタンスを使う！Interceptorが付いてない
  final refreshDio = Dio(
    BaseOptions(
      baseUrl: baseUrl!,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      validateStatus: (status) => status != null && status < 500,
    ),
  );
  return UploadRepository(
    client: client,
    dio: refreshDio,
    storage: storage,
    getDeviceInfoFn: () => getDeviceInfoFn(),
  );
}
