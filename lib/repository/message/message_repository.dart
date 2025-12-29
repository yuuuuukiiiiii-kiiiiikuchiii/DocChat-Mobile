import 'package:dio/dio.dart';
import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/message/message.dart';
import 'package:rag_faq_document/repository/dio/authenticated_dio_client.dart';

class MessageRepository {
  final AuthenticatedDioClient client;
  MessageRepository({required this.client});

  Future<Message> postMessage({
    required String message,
    required int sessionId,
    required int documentId,
    required String title,
  }) async {
    try {
      final response = await client.dio.post(
        '/chats/$sessionId/messages',
        data: {"message": message, "document_id": documentId, "title": title},
        options: Options(contentType: "application/json"),
      );
      if (response.statusCode == 200) {
        return Message.fromJson(response.data);
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

  Future<List<Message>> listMessage({required int sessionId}) async {
    try {
      final response = await client.dio.get(
        '/chats/$sessionId/messages',
        options: Options(contentType: "application/json"),
      );
      if (response.statusCode == 200) {
        return (response.data as List<dynamic>)
            .map((json) => Message.fromJson(json))
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
}
