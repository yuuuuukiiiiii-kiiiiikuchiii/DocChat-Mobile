import 'package:flutter_test/flutter_test.dart';
import 'package:rag_faq_document/models/upload/upload.dart';

void main() {
  group('UploadResponse', () {
    test('正常にインスタンスが作成される', () {
      final response = UploadResponse(
        documentId: 123,
        status: 'success',
        filename: 'example.pdf',
      );

      expect(response.documentId, 123);
      expect(response.status, 'success');
      expect(response.filename, 'example.pdf');
    });

    test('fromJsonで正しくデコードされる', () {
      final json = {
        "document_id": 123,
        "status": "success",
        "filename": "example.pdf",
      };

      final response = UploadResponse.fromJson(json);

      expect(response.documentId, 123);
      expect(response.status, 'success');
      expect(response.filename, 'example.pdf');
    });

    test('toJsonで正しくエンコードされる', () {
      final response = UploadResponse(
        documentId: 123,
        status: 'success',
        filename: 'example.pdf',
      );

      final json = response.toJson();

      expect(json["document_id"], 123);
      expect(json["status"], 'success');
      expect(json["filename"], 'example.pdf');
    });

    test('copyWithが正しく動作する', () {
      final original = UploadResponse(
        documentId: 123,
        status: 'success',
        filename: 'example.pdf',
      );

      final modified = original.copyWith(status: 'failed');

      expect(modified.documentId, 123);
      expect(modified.status, 'failed');
      expect(modified.filename, 'example.pdf');
    });

    test('等価性が正しく機能する', () {
      final a = UploadResponse(
        documentId: 123,
        status: 'success',
        filename: 'example.pdf',
      );
      final b = UploadResponse(
        documentId: 123,
        status: 'success',
        filename: 'example.pdf',
      );

      expect(a, equals(b));
    });
  });
}
