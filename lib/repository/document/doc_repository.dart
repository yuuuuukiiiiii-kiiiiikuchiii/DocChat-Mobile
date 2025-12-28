import 'package:dio/dio.dart';
import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/document/documents_response/documents_response.dart';
import 'package:rag_faq_document/repository/dio/authenticated_dio_client.dart';

class DocRepository {
  final AuthenticatedDioClient client;
  DocRepository({required this.client});

  Future<List<DocumentsResponse>> listDocument() async {
    try {
      final response = await client.dio.get('/documents',options: Options(contentType: "application/json"),);
      if (response.statusCode == 200) {
        final data = response.data;

        if (data == null || data is! List) {
          // ここで null や 不正な形式 をキャッチ
          return [];
        }

        return data
            .map<DocumentsResponse>((doc) => DocumentsResponse.fromJson(doc))
            .toList();
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

  Future<void> editTitleDocument({
    required String newTitle,
    required int documentId,
  }) async {
    try {
      print("start editTitleDocument");
      final response = await client.dio.put(
        "/documents/update",
        options: Options(contentType: "application/json"),
        data: {'document_id': documentId, 'title': newTitle},
      );
      if(response.statusCode == 200){
        print(response.data);
      }
      if (response.statusCode != 200) {
        throw HttpErrorException(
          message: (response.data["error"]).toString(),
          statusCode: response.statusCode!,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDocument(int documentId) async {
    try {
      final response = await client.dio.delete('/documents/$documentId',options: Options(contentType: "application/json"),);
      if (response.statusCode != 200) {
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
