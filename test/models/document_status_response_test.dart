import 'package:flutter_test/flutter_test.dart';
import 'package:rag_faq_document/models/document/document_status_response/document_status_response.dart';

void main() {
  group('DocumentStatusResponse', () {
    test('インスタンスが正常に生成される', () {
      final doc = DocumentStatusResponse(
        documentId: 1,
        chatId: 10,
        filename: 'test.pdf',
        status: 'uploaded',
      );

      expect(doc.documentId, 1);
      expect(doc.chatId, 10);
      expect(doc.filename, 'test.pdf');
      expect(doc.status, 'uploaded');
    });

    test('chatIdがnullでも生成される', () {
      final doc = DocumentStatusResponse(
        documentId: 2,
        chatId: null,
        filename: 'nullchat.pdf',
        status: 'processing',
      );

      expect(doc.chatId, isNull);
      expect(doc.filename, 'nullchat.pdf');
    });

    test('fromJsonで正しく変換される', () {
      final json = {
        "document_id": 3,
        "chat_id": 30,
        "filename": "doc.pdf",
        "status": "completed"
      };

      final doc = DocumentStatusResponse.fromJson(json);

      expect(doc.documentId, 3);
      expect(doc.chatId, 30);
      expect(doc.filename, 'doc.pdf');
      expect(doc.status, 'completed');
    });

    test('toJsonで正しく変換される', () {
      final doc = DocumentStatusResponse(
        documentId: 4,
        chatId: 40,
        filename: 'sample.pdf',
        status: 'done',
      );

      final json = doc.toJson();

      expect(json["document_id"], 4);
      expect(json["chat_id"], 40);
      expect(json["filename"], 'sample.pdf');
      expect(json["status"], 'done');
    });

    test('copyWithが正しく動作する', () {
      final original = DocumentStatusResponse(
        documentId: 5,
        chatId: 50,
        filename: 'original.pdf',
        status: 'pending',
      );

      final modified = original.copyWith(status: 'completed');

      expect(modified.status, 'completed');
      expect(modified.documentId, 5);
      expect(modified.chatId, 50);
      expect(modified.filename, 'original.pdf');
    });

    test('等価性が正しく動作する', () {
      final a = DocumentStatusResponse(
        documentId: 6,
        chatId: 60,
        filename: 'equal.pdf',
        status: 'same',
      );

      final b = DocumentStatusResponse(
        documentId: 6,
        chatId: 60,
        filename: 'equal.pdf',
        status: 'same',
      );

      expect(a, equals(b));
    });
  });
}
