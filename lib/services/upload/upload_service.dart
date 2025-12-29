import 'dart:io';

import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/models/upload/upload.dart';
import 'package:rag_faq_document/repository/handle_exception.dart';
import 'package:rag_faq_document/repository/upload/upload_repository.dart';
import 'package:rag_faq_document/utils/utils.dart';

class UploadService {
  final UploadRepository repo;
  UploadService({required this.repo});

  Future<int> newUpload({
    required File filePath,
    required String fileName,
    required String mimeType,
  }) async {
    try {
      //presign
      final presign = await repo.presign(
        fileName: fileName,
        mimeType: mimeType,
      );
      final presignedUrl = presign.presignedUrl;

      //S3にアップロード
      await repo.uploadS3(
        presignedUrl: presignedUrl,
        file: filePath,
        mimeType: mimeType,
      );

      final documentId = presign.documentId;

      return documentId;
    } on HttpErrorException catch (e) {
      final userMessage = mapHttpErrorToUserMessage(e.message, e.statusCode);
      throw CustomError.server(
        statusCode: e.statusCode,
        message: e.message,
        userMessage: userMessage,
      );
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<UploadResponse> uploadFile({
    required String filePath,
    required String fileName,
    required String fileType,
  }) async {
    try {
      final data = await repo.uploadFile(
        filePath: filePath,
        filename: fileName,
        fileType: fileType,
      );
      return data;
    } on HttpErrorException catch (e) {
      final userMessage = mapHttpErrorToUserMessage(e.message, e.statusCode);
      throw CustomError.server(
        statusCode: e.statusCode,
        message: e.message,
        userMessage: userMessage,
      );
    } catch (e) {
      throw handleException(e);
    }
  }
}
