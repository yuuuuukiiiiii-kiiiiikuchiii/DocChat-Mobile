import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:rag_faq_document/repository/auth/auth_repository.dart';
import 'package:rag_faq_document/repository/chat/chat_repository.dart';
import 'package:rag_faq_document/repository/dio/authenticated_dio_client.dart';
import 'package:rag_faq_document/repository/local_storage/local_storage.dart';
import 'package:rag_faq_document/repository/message/message_repository.dart';
import 'package:rag_faq_document/repository/upload/upload_repository.dart';
import 'package:rag_faq_document/services/auth/auth_service.dart';
import 'package:rag_faq_document/utils/utils.dart';

@GenerateMocks([
  FlutterSecureStorage,
  DeviceInfoWrapper,
  Dio,
  LocalStorage,
  AuthenticatedDioClient,
  MultipartFile,
  AuthRepository,
  ChatRepository,
  UploadRepository,
  MessageRepository,
  AuthService,
])
void main() {}
