import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/chat/chat.dart';
import 'package:rag_faq_document/repository/dio/authenticated_dio_client.dart';

class ChatRepository {
  final AuthenticatedDioClient client;

  ChatRepository({required this.client});

  Future<List<Chat>> listChats({
    required int pageId,
    required int pageSize,
  }) async {
    try {
      final response = await client.dio.get(
        "/chats",
        queryParameters: {
          'page_id': pageId.toString(),
          'page_size': pageSize.toString(),
        },
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => Chat.fromJson(json))
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

  Future<Chat> getChat({required int id}) async {
    try {
      final response = await client.dio.get('/chats/$id');
      if (response.statusCode == 200) {
        return Chat.fromJson(response.data);
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

  Future<Chat> createChat({
    required int documentId,
    required String title,
  }) async {
    try {
      final response = await client.dio.post(
        '/chats/session',
        data: {'document_id': documentId, 'title': title},
      );
      if (response.statusCode == 200) {
        return Chat.fromJson(response.data);
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
