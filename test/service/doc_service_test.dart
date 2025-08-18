import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/document/document_status_response/document_status_response.dart';
import 'package:rag_faq_document/models/document/documents_response/documents_response.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/models/upload/upload.dart';
import 'package:rag_faq_document/services/upload/upload_service.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  late MockDocRepository mockRepo;
  late UploadService docService;

  setUp(() {
    mockRepo = MockDocRepository();
    docService = UploadService(repo: mockRepo);
  });

  group('DocService', () {
    test('uploadFile success', () async {
      final response = UploadResponse(
        documentId: 1,
        status: "completed",
        filename: 'title1',
      );

      when(
        mockRepo.uploadFile(
          filePath: anyNamed('filePath'),
          filename: anyNamed('filename'),
          fileType: anyNamed('fileType'),
        ),
      ).thenAnswer((_) async => response);

      final result = await docService.uploadFile(
        filePath: 'dummy.pdf',
        fileName: 'dummy.pdf',
        fileType: 'pdf',
      );

      expect(result, equals(response));
    });

    test(
      'uploadFile throws CustomError.server on HttpErrorException',
      () async {
        when(
          mockRepo.uploadFile(
            filePath: anyNamed('filePath'),
            filename: anyNamed('filename'),
            fileType: anyNamed('fileType'),
          ),
        ).thenThrow(
          HttpErrorException(message: 'Upload failed', statusCode: 400),
        );

        expect(
          () => docService.uploadFile(filePath: '', fileName: '', fileType: ''),
          throwsA(isA<CustomError>()),
        );
      },
    );

    test('uploadFile throws CustomError.other on unexpected error', () async {
      when(
        mockRepo.uploadFile(
          filePath: anyNamed('filePath'),
          filename: anyNamed('filename'),
          fileType: anyNamed('fileType'),
        ),
      ).thenThrow(Exception('Unexpected error'));

      expect(
        () => docService.uploadFile(filePath: '', fileName: '', fileType: ''),
        throwsA(isA<CustomError>()),
      );
    });

    test('listDocument success', () async {
      final list = [
        DocumentsResponse(id: 1, filename: '', filetype: '', fileurl: ''),
      ];

      when(mockRepo.listDocument()).thenAnswer((_) async => list);

      final result = await docService.listDocument();
      expect(result, equals(list));
    });

    test('listDocument HttpErrorException', () async {
      when(
        mockRepo.listDocument(),
      ).thenThrow(HttpErrorException(message: 'Not found', statusCode: 404));

      expect(() => docService.listDocument(), throwsA(isA<CustomError>()));
    });

    test('listDocument unexpected error', () async {
      when(mockRepo.listDocument()).thenThrow(Exception('Fail'));

      expect(() => docService.listDocument(), throwsA(isA<CustomError>()));
    });

    test('getDocumentStatus success', () async {
      final response = DocumentStatusResponse(
        chatId: 1,
        status: 'ready',
        documentId: 1,
        filename: 'title1',
      );

      when(mockRepo.getDocumentStatus(1)).thenAnswer((_) async => response);

      final result = await docService.getDocumentStatus(1);
      expect(result, equals(response));
    });

    test('getDocumentStatus HttpErrorException', () async {
      when(
        mockRepo.getDocumentStatus(1),
      ).thenThrow(HttpErrorException(message: 'Unauthorized', statusCode: 401));

      expect(
        () => docService.getDocumentStatus(1),
        throwsA(isA<CustomError>()),
      );
    });

    test('getDocumentStatus unexpected error', () async {
      when(mockRepo.getDocumentStatus(1)).thenThrow(Exception('error'));

      expect(
        () => docService.getDocumentStatus(1),
        throwsA(isA<CustomError>()),
      );
    });

    test('cancelUpload success', () async {
      when(mockRepo.cancelUpload(1)).thenAnswer((_) async {});

      await docService.cancelUpload(1);

      verify(mockRepo.cancelUpload(1)).called(1);
    });

    test('cancelUpload HttpErrorException', () async {
      when(
        mockRepo.cancelUpload(1),
      ).thenThrow(HttpErrorException(message: 'Conflict', statusCode: 409));

      expect(() => docService.cancelUpload(1), throwsA(isA<CustomError>()));
    });

    test('cancelUpload unexpected error', () async {
      when(mockRepo.cancelUpload(1)).thenThrow(Exception('unexpected'));

      expect(() => docService.cancelUpload(1), throwsA(isA<CustomError>()));
    });
  });
}
