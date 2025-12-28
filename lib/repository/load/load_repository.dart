import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/document/document_status_response/document_status_response.dart';
import 'package:rag_faq_document/repository/dio/authenticated_dio_client.dart';

class LoadRepository {
  final Ref ref;
  final AuthenticatedDioClient client;

  LoadRepository({required this.ref, required this.client});

  Future<DocumentStatusResponse> uploadComplete(int documentId) async {
    try {
      final response = await client.dio.post('/upload/$documentId/complete');
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
