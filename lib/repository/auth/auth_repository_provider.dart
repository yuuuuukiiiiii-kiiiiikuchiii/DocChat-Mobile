import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_faq_document/repository/auth/auth_repository.dart';
import 'package:rag_faq_document/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  final url = "${dotenv.env["BASEURL"]!}/auth";
  final dio = Dio(
    BaseOptions(
      baseUrl:url,
      contentType: 'application/json',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      validateStatus: (status) => status != null && status < 600,
    ),
  );

  final getDeviceInfoFn = DeviceInfoWrapperImpl().getDeviceName;

  return AuthRepository(dio: dio, getDeviceInfoFn: () => getDeviceInfoFn());
}
