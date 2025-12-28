import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/document/document_status_response/document_status_response.dart';
import 'package:rag_faq_document/models/upload/upload.dart';
import 'package:rag_faq_document/models/upload/upload_presign/upload_presign.dart';
import 'package:rag_faq_document/repository/dio/authenticated_dio_client.dart';

class UploadRepository {
  final Ref ref;
  final AuthenticatedDioClient client;
  final Dio dio;

  UploadRepository({
    required this.ref,
    required this.client,
    required this.dio,
  });

  Future<UploadPresign> presign({
    required String fileName,
    required String mimeType,
  }) async {
    try {
      final response = await client.dio.post(
        '/upload/presign',
        data: {'file_name': fileName, 'mime_type': mimeType},
      );
      if (response.statusCode == 200) {
        return UploadPresign.fromJson(response.data);
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

  Future<void> uploadS3({
    required String presignedUrl,
    required File file,
    required String mimeType,
  }) async {
    try {
      // ファイルをバイト列で読み込む
      final bytes = await file.readAsBytes();

      final response = await dio.put(
        presignedUrl,
        data: bytes,
        options: Options(headers: {"Content-Type": mimeType}),
      );

      if (response.statusCode == 200) {
        print("Upload success");
      }
    } on DioException catch (e) {
      // S3 からの HTTP レスポンスがある場合
      final statusCode = e.response?.statusCode ?? 0;

      switch (statusCode) {
        case 400:
          throw HttpErrorException(
            message: 'アップロード内容が不正です（Content-Type や署名条件を確認してください）',
            statusCode: 400,
          );
        case 403:
          throw HttpErrorException(
            message: 'アップロードが拒否されました（期限切れ or 不正署名）',
            statusCode: 403,
          );
        case 0:
          throw HttpErrorException(message: 'ネットワークエラーです', statusCode: 0);
        default:
          throw HttpErrorException(
            message: 'アップロードに失敗しました（status: $statusCode）',
            statusCode: statusCode,
          );
      }
    } catch (e) {
      rethrow;
    }
  }

  // Future<UploadResponse> uploadComplete(int documentId) async {
  //   try {
  //     final response = await client.dio.post('/upload/$documentId/complete');
  //     if (response.statusCode == 200) {
  //       return UploadResponse.fromJson(response.data);
  //     } else {
  //       throw HttpErrorException(
  //         message: (response.data["error"]).toString(),
  //         statusCode: response.statusCode!,
  //       );
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

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

      final formData = FormData.fromMap({
        "filename": filename,
        "fileType": fileType,
        "file": multipartFile,
      });

      final response = await client.dio.post(
        '/upload',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          extra: {
            // ← 再送時に呼ぶ「FormData再生成関数」
            'recreateFormData':
                () async => FormData.fromMap({
                  'filename': filename,
                  'fileType': fileType,
                  'file': await MultipartFile.fromFile(
                    filePath,
                    filename: filename,
                  ),
                }),
          },
        ),
      );

      if (response.statusCode == 202) {
        return UploadResponse.fromJson(response.data);
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
}
