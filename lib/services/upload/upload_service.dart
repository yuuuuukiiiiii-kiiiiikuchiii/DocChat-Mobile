import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/document/document_status_response/document_status_response.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/models/upload/upload.dart';
import 'package:rag_faq_document/repository/handle_exception.dart';
import 'package:rag_faq_document/repository/upload/upload_repository.dart';
import 'package:rag_faq_document/utils/utils.dart';

class UploadService {
  final UploadRepository repo;
  UploadService({required this.repo});

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

  Future<DocumentStatusResponse> getDocumentStatus(int documentId) async {
    try {
      final data = await repo.getDocumentStatus(documentId);
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

  Future<void> cancelUpload(documentId) async {
    try {
      await repo.cancelUpload(documentId);
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
