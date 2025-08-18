import 'package:flutter_test/flutter_test.dart';
import 'package:rag_faq_document/models/message/message.dart';

void main() {
  group('Message model', () {
    final testJson = {
      "id": 1,
      "session_id": 10,
      "is_user": true,
      "message": "Hello",
      "created_at": "2025-06-17T12:00:00.000Z",
    };

    test('fromJson creates Message instance', () {
      final msg = Message.fromJson(testJson);

      expect(msg.id, 1);
      expect(msg.sessionId, 10);
      expect(msg.isUser, true);
      expect(msg.message, "Hello");
      expect(msg.createdAt, DateTime.parse("2025-06-17T12:00:00.000Z"));
    });

    test('toJson returns correct map', () {
      final msg = Message(
        id: 1,
        sessionId: 10,
        isUser: true,
        message: "Hello",
        createdAt: DateTime.parse("2025-06-17T12:00:00.000Z"),
      );

      final json = msg.toJson();

      expect(json["id"], 1);
      expect(json["session_id"], 10);
      expect(json["is_user"], true);
      expect(json["message"], "Hello");
      expect(json["created_at"], "2025-06-17T12:00:00.000Z");
    });

    test('typing factory returns default typing Message', () {
      final msg = Message.typing();

      expect(msg.id, -1);
      expect(msg.sessionId, -1);
      expect(msg.isUser, false);
      expect(msg.message, "");
      expect(msg.createdAt, isA<DateTime>());
    });

    test('add factory returns custom Message', () {
      final msg = Message.add(
        id: 5,
        sessionId: 42,
        message: "test message",
        isUser: false,
        createdAt: DateTime.parse("2025-06-18T10:00:00.000Z"),
      );

      expect(msg.id, 5);
      expect(msg.sessionId, 42);
      expect(msg.message, "test message");
      expect(msg.isUser, false);
      expect(msg.createdAt, DateTime.parse("2025-06-18T10:00:00.000Z"));
    });
  });
}
