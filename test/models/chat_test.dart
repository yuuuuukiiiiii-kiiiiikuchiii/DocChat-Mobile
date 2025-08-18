import 'package:flutter_test/flutter_test.dart';
import 'package:rag_faq_document/models/chat/chat.dart';

void main() {
  group('Chat model', () {
    final json = {
      "id": 1,
      "user_id": 10,
      "document_id": 20,
      "title": "Test Document",
      "created_at": "2025-06-17T12:34:56.000Z",
      "updated_at": "2025-06-17T13:00:00.000Z"
    };

    test('fromJson creates Chat instance', () {
      final chat = Chat.fromJson(json);

      expect(chat.id, 1);
      expect(chat.userId, 10);
      expect(chat.documentId, 20);
      expect(chat.title, "Test Document");
      expect(chat.createdAt, DateTime.parse("2025-06-17T12:34:56.000Z"));
      expect(chat.updatedAt, DateTime.parse("2025-06-17T13:00:00.000Z"));
    });

    test('toJson returns correct map', () {
      final chat = Chat(
        id: 1,
        userId: 10,
        documentId: 20,
        title: "Test Document",
        createdAt: DateTime.parse("2025-06-17T12:34:56.000Z"),
        updatedAt: DateTime.parse("2025-06-17T13:00:00.000Z"),
      );

      final jsonResult = chat.toJson();

      expect(jsonResult["id"], 1);
      expect(jsonResult["user_id"], 10);
      expect(jsonResult["document_id"], 20);
      expect(jsonResult["title"], "Test Document");
      expect(jsonResult["created_at"], "2025-06-17T12:34:56.000Z");
      expect(jsonResult["updated_at"], "2025-06-17T13:00:00.000Z");
    });
  });
}
