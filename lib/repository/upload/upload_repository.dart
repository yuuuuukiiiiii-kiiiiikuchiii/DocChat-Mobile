import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/auth/user_response.dart';
import 'package:rag_faq_document/models/document/document_status_response/document_status_response.dart';
import 'package:rag_faq_document/models/upload/upload.dart';
import 'package:rag_faq_document/repository/dio/authenticated_dio_client.dart';
import 'package:rag_faq_document/repository/local_storage/local_storage.dart';

class UploadRepository {
  final AuthenticatedDioClient client;
  final Dio dio;
  final LocalStorage storage;
  final Future<String> Function() getDeviceInfoFn;

  UploadRepository({
    required this.client,
    required this.dio,
    required this.storage,
    required this.getDeviceInfoFn,
  });

  Future<UploadResponse> uploadFile({
    required String filePath,
    required String filename,
    required String fileType,
    MultipartFile? multipartFileForTest, // ←追加
  }) async {
    try {
      final multipartFile =
          multipartFileForTest ??
          await MultipartFile.fromFile(filePath, filename: filename);
      //1
      final formData = FormData.fromMap({
        "filename": filename,
        "fileType": fileType,
        "file": multipartFile,
      });
      //2
      final accessToken = await storage.getAccessToken();
      final response = await dio.post(
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        '/upload',
        data: formData,
      );
      //3
      if (response.statusCode == 202) {
        return UploadResponse.fromJson(response.data);
        //4
      } else if (response.statusCode == 401) {
        //6
        final success = await refreshToken(); // ← 直接リフレッシュ
        if (success) {
          //7
          // トークン更新後に再試行
          final formDataRetry = FormData.fromMap({
            "filename": filename,
            "fileType": fileType,
            "file": await MultipartFile.fromFile(filePath, filename: filename),
          });
          //8
          final newAccessToken = await storage.getAccessToken();
          final retryResponse = await dio.post(
            options: Options(
              headers: {'Authorization': 'Bearer $newAccessToken'},
            ),
            '/upload',
            data: formDataRetry,
          );
          if (retryResponse.statusCode == 202) {
            return UploadResponse.fromJson(retryResponse.data);
          } else {
            throw HttpErrorException(
              message: retryResponse.data["error"].toString(),
              statusCode: retryResponse.statusCode!,
            );
          }
        } else {
          //11
          throw HttpErrorException(
            message: (response.data["error"]).toString(),
            statusCode: response.statusCode!,
          );
        }
      } else {
        //5
        throw HttpErrorException(
          message: (response.data["error"]).toString(),
          statusCode: response.statusCode!,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DocumentStatusResponse> getDocumentStatus(int documentId) async {
    try {
      final response = await client.dio.get('/upload/$documentId');
      if (response.statusCode == 200) {
        return DocumentStatusResponse.fromJson(response.data);
      } else {
        throw HttpErrorException(
          message: (response.data["error"]).toString(),
          statusCode: response.statusCode!,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelUpload(documentId) async {
    try {
      final response = await client.dio.delete('/upload/cancel/$documentId');
      if (response.statusCode == 204) {
        return;
      } else {
        throw HttpErrorException(
          message: (response.data["error"]).toString(),
          statusCode: response.statusCode!,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> refreshToken() async {
    final deviceInfo = await getDeviceInfoFn();
    print("refresh start");
    final refreshToken = await storage.getRefreshToken();
    final baseUrl = dotenv.env["BASEURL"];
    if (refreshToken == null || baseUrl == null) return false;

    // 別のDioインスタンスを使う！Interceptorが付いてない
    final refreshDio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );
    try {
      final response = await refreshDio.post(
        "/tokens/renew_access",
        data: {"refresh_token": refreshToken},
        options: Options(
          headers: {'Authorization': '', 'User-Agent': deviceInfo},
        ),
      );
      final responseData = response.data;
      print(responseData);
      final data = UserResponse.fromJson(responseData);
      print(data);
      await storage.saveTokens(
        accessToken: data.accessToken,
        accessTokenExpiresAt: data.accessTokenExpiresAt,
        refreshToken: data.refreshToken,
        refreshTokenExpiresAt: data.refreshTokenExpiresAt,
      );
      print("リフレッシュトークン取得成功");
      return true;
    } catch (e) {
      print("リフレッシュ失敗: $e");
      return false;
    }
  }
}
