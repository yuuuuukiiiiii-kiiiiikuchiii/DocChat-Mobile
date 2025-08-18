import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/document/documents_response/documents_response.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/repository/document/doc_repository.dart';
import 'package:rag_faq_document/repository/handle_exception.dart';
import 'package:rag_faq_document/utils/utils.dart';

class DocService {
  final DocRepository repo;
  DocService({required this.repo});

  Future<List<DocumentsResponse>> listDocument() async {
    try {
      final data = await repo.listDocument();
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

  Future<void> editTitleDocument({
    required String newTitle,
    required int documentId,
  }) async {
    try {
      await repo.editTitleDocument(newTitle: newTitle, documentId: documentId);
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

  Future<void> deleteDocument(int documentId) async {
    try {
      await repo.deleteDocument(documentId);
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
