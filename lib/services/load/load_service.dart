import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/document/document_status_response/document_status_response.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/repository/handle_exception.dart';
import 'package:rag_faq_document/repository/load/load_repository.dart';
import 'package:rag_faq_document/utils/utils.dart';

class LoadService {
  final LoadRepository repo;
  LoadService({required this.repo});

  Future<DocumentStatusResponse> uploadComplete({
    required int documentId,
  }) async {
    try {
      return await repo.uploadComplete(documentId);
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

  Future<DocumentStatusResponse> getDocumentStatus({
    required int documentId,
  }) async {
    try {
      return await repo.getDocumentStatus(documentId);
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
      return await repo.cancelUpload(documentId);
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
