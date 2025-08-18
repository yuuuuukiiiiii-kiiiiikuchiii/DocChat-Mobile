import 'package:flutter_test/flutter_test.dart';
import 'package:rag_faq_document/models/document/documents_response/documents_response.dart';

void main() {
  group('DocumentsResponse', () {
    test('正常にインスタンスが作成される', () {
      final doc = DocumentsResponse(
        id: 1,
        filename: 'report.pdf',
        filetype: 'pdf',
        fileurl: 'https://example.com/report.pdf',
      );

      expect(doc.id, 1);
      expect(doc.filename, 'report.pdf');
      expect(doc.filetype, 'pdf');
      expect(doc.fileurl, 'https://example.com/report.pdf');
    });

    test('fromJsonで正しく変換される', () {
      final json = {
        "id": 2,
        "filename": "test.docx",
        "filetype": "docx",
        "fileurl": "https://example.com/test.docx",
      };

      final doc = DocumentsResponse.fromJson(json);

      expect(doc.id, 2);
      expect(doc.filename, 'test.docx');
      expect(doc.filetype, 'docx');
      expect(doc.fileurl, 'https://example.com/test.docx');
    });

    test('toJsonで正しく変換される', () {
      final doc = DocumentsResponse(
        id: 3,
        filename: 'notes.txt',
        filetype: 'txt',
        fileurl: 'https://example.com/notes.txt',
      );

      final json = doc.toJson();

      expect(json['id'], 3);
      expect(json['filename'], 'notes.txt');
      expect(json['filetype'], 'txt');
      expect(json['fileurl'], 'https://example.com/notes.txt');
    });

    test('copyWithが正しく動作する', () {
      final original = DocumentsResponse(
        id: 4,
        filename: 'data.csv',
        filetype: 'csv',
        fileurl: 'https://example.com/data.csv',
      );

      final modified = original.copyWith(filename: 'updated.csv');

      expect(modified.id, 4);
      expect(modified.filename, 'updated.csv');
      expect(modified.filetype, 'csv');
      expect(modified.fileurl, 'https://example.com/data.csv');
    });

    test('等価性が正しく機能する', () {
      final a = DocumentsResponse(
        id: 5,
        filename: 'same.txt',
        filetype: 'txt',
        fileurl: 'https://example.com/same.txt',
      );
      final b = DocumentsResponse(
        id: 5,
        filename: 'same.txt',
        filetype: 'txt',
        fileurl: 'https://example.com/same.txt',
      );

      expect(a, equals(b));
    });
  });
}
