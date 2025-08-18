import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/repository/upload/upload_repository.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // ★これを追加
  late MockDio mockDio;
  late MockAuthenticatedDioClient mockClient;
  late MockLocalStorage mockStorage;
  late UploadRepository repository;

  setUp(() async {
    mockDio = MockDio();
    mockClient = MockAuthenticatedDioClient();
    mockStorage = MockLocalStorage();

    when(mockClient.dio).thenReturn(mockDio);

    repository = UploadRepository(
      client: mockClient,
      dio: mockDio,
      storage: mockStorage,
      getDeviceInfoFn: () async => 'mock-device',
    );
  });

  group('uploadFile', () {
    test('uploadFileでサーバーエラーが発生', () async {
      when(mockStorage.getAccessToken()).thenAnswer((_) async => 'token');

      final mockFile = MultipartFile.fromBytes([1, 2, 3], filename: 'fail.pdf');

      when(
        mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/documents/upload'),
          statusCode: 500,
          data: {'error': 'server error'},
        ),
      );

      expect(
        () => repository.uploadFile(
          filePath: '/path/fail.pdf',
          filename: 'fail.pdf',
          fileType: 'pdf',
          multipartFileForTest: mockFile,
        ),
        throwsA(isA<HttpErrorException>()),
      );
    });

    test('正常にアップロード成功', () async {
      when(mockStorage.getAccessToken()).thenAnswer((_) async => 'token');

      final mockFile = MultipartFile.fromBytes([1, 2, 3], filename: 'test.pdf');

      when(
        mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/documents/upload'),
          statusCode: 202,
          data: {
            "document_id": 1,
            "status": "processing",
            "filename": "test.pdf",
          },
        ),
      );

      final result = await repository.uploadFile(
        filePath: '/dummy/path/test.pdf',
        filename: 'test.pdf',
        fileType: 'pdf',
        multipartFileForTest: mockFile,
      );

      expect(result.filename, 'test.pdf');
    });

    test('401のあとリフレッシュして成功', () async {
      final mockFile = MultipartFile.fromBytes([
        1,
        2,
        3,
      ], filename: 'retry.pdf');

      // 初回アクセストークン
      when(mockStorage.getAccessToken()).thenAnswer((_) async => 'old_token');

      // 初回401エラー
      when(
        mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/documents/upload'),
          statusCode: 401,
          data: {'error': 'unauthorized'},
        ),
      );

      // トークンリフレッシュ処理（この後 getAccessToken 再呼び出しを考慮）
      when(
        mockStorage.getRefreshToken(),
      ).thenAnswer((_) async => 'refresh_token');

      when(
        mockDio.post(
          '/tokens/renew_access',
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/tokens/renew_access'),
          statusCode: 200,
          data: {
            'access_token': 'new_token',
            'access_token_expires_at': '2030-01-01T00:00:00Z',
            'refresh_token': 'new_refresh_token',
            'refresh_token_expires_at': '2030-02-01T00:00:00Z',
          },
        ),
      );

      // 新しいトークンで再試行時の成功レスポンス
      when(mockStorage.getAccessToken()).thenAnswer((_) async => 'new_token');
      when(
        mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/documents/upload'),
          statusCode: 202,
          data: {
            "document_id": 1,
            "status": "processing",
            "filename": "retry.pdf",
          },
        ),
      );

      final result = await repository.uploadFile(
        filePath: '/dummy/path/test.pdf',
        filename: 'retry.pdf',
        fileType: 'pdf',
        multipartFileForTest: mockFile,
      );

      expect(result.filename, 'retry.pdf');
    });
  });

  group('listDocument', () {
    test('listDocumentで403エラーが返る', () async {
      when(mockDio.get('/documents')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/documents'),
          statusCode: 403,
          data: {"error": "forbidden"},
        ),
      );

      expect(
        () => repository.listDocument(),
        throwsA(isA<HttpErrorException>()),
      );
    });

    test('正常に一覧取得', () async {
      when(mockDio.get('/documents')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/documents'),
          statusCode: 200,
          data: [
            {
              "id": 1,
              "filename": "doc1.pdf",
              "filetype": "pdf",
              "fileurl": "https://example.com/doc1.pdf",
            },
          ],
        ),
      );

      final result = await repository.listDocument();
      expect(result.length, 1);
      expect(result.first.filename, 'doc1.pdf');
    });
  });

  group('getDocumentStatus', () {
    test('getDocumentStatusで404エラー', () async {
      when(mockDio.get('/documents/999')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/documents/999'),
          statusCode: 404,
          data: {'error': 'not found'},
        ),
      );

      expect(
        () => repository.getDocumentStatus(999),
        throwsA(isA<HttpErrorException>()),
      );
    });

    test('正常に取得', () async {
      when(mockDio.get('/documents/1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/documents/1'),
          statusCode: 200,
          data: {
            "document_id": 1,
            "filename": "test.pdf",
            "status": "processing",
            "chat_id": null,
          },
        ),
      );

      final result = await repository.getDocumentStatus(1);
      expect(result.documentId, 1);
    });
  });

  group('cancelUpload', () {
    test('cancelUploadでエラーが返る', () async {
      when(mockDio.delete('/documents/cancel/999')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/documents/cancel/999'),
          statusCode: 400,
          data: {"error": "bad request"},
        ),
      );

      expect(
        () => repository.cancelUpload(999),
        throwsA(isA<HttpErrorException>()),
      );
    });

    test('204で成功', () async {
      when(mockDio.delete('/documents/cancel/1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/documents/cancel/1'),
          statusCode: 204,
        ),
      );

      await expectLater(repository.cancelUpload(1), completes);
    });
  });

  test('_refreshToken中にsaveTokensで例外が起きた場合', () async {
    dotenv.testLoad(fileInput: 'BASEURL=https://example.com');

    when(
      mockStorage.getRefreshToken(),
    ).thenAnswer((_) async => 'refresh_token');

    when(
      mockDio.post(
        '/tokens/renew_access',
        data: anyNamed('data'),
        options: anyNamed('options'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/tokens/renew_access'),
        statusCode: 200,
        data: {
          'access_token': 'new_token',
          'access_token_expires_at': '2030-01-01T00:00:00Z',
          'refresh_token': 'new_refresh_token',
          'refresh_token_expires_at': '2030-02-01T00:00:00Z',
        },
      ),
    );

    when(
      mockStorage.saveTokens(
        accessToken: anyNamed('accessToken'),
        accessTokenExpiresAt: anyNamed('accessTokenExpiresAt'),
        refreshToken: anyNamed('refreshToken'),
        refreshTokenExpiresAt: anyNamed('refreshTokenExpiresAt'),
      ),
    ).thenThrow(Exception('保存失敗'));

    final result = await repository.refreshToken();
    expect(result, false);
  });

  test('再アップロード時にファイル読み込み失敗', () async {
    final mockFile = MultipartFile.fromBytes([1, 2, 3], filename: 'fail2.pdf');

    when(mockStorage.getAccessToken()).thenAnswer((_) async => 'expired_token');

    // 初回401
    when(
      mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/documents/upload'),
        statusCode: 401,
        data: {'error': 'unauthorized'},
      ),
    );

    // refresh成功
    dotenv.testLoad(fileInput: 'BASEURL=https://example.com');

    when(
      mockStorage.getRefreshToken(),
    ).thenAnswer((_) async => 'refresh_token');

    // refresh成功
    when(
      mockDio.post(
        '/tokens/renew_access',
        data: anyNamed('data'),
        options: anyNamed('options'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/tokens/renew_access'),
        statusCode: 200,
        data: {
          'access_token': 'new_token',
          'access_token_expires_at': '2030-01-01T00:00:00Z',
          'refresh_token': 'new_refresh_token',
          'refresh_token_expires_at': '2030-02-01T00:00:00Z',
        },
      ),
    );

    // ファイル読み込みでエラー（パスが不正）
    expect(
      () => repository.uploadFile(
        filePath: '/invalid/path.pdf',
        filename: 'fail2.pdf',
        fileType: 'pdf',
        multipartFileForTest: mockFile,
      ),
      throwsException,
    );
  });

  test('refreshTokenがサーバーエラーで失敗する', () async {
    dotenv.testLoad(fileInput: 'BASEURL=https://example.com');

    when(
      mockStorage.getRefreshToken(),
    ).thenAnswer((_) async => 'refresh_token');

    when(
      mockDio.post(
        '/tokens/renew_access',
        data: anyNamed('data'),
        options: anyNamed('options'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/tokens/renew_access'),
        statusCode: 500,
        data: {'error': 'internal error'},
      ),
    );

    final result = await repository.refreshToken();
    expect(result, false);
  });

  test('cancelUploadでエラーメッセージなし', () async {
    when(mockDio.delete('/documents/cancel/999')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/documents/cancel/999'),
        statusCode: 400,
        data: {}, // errorがない
      ),
    );

    expect(
      () => repository.cancelUpload(999),
      throwsA(isA<HttpErrorException>()),
    );
  });

  test('getDocumentStatusでchat_idあり', () async {
    when(mockDio.get('/documents/1')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/documents/1'),
        statusCode: 200,
        data: {
          "document_id": 1,
          "filename": "test.pdf",
          "status": "done",
          "chat_id": 123,
        },
      ),
    );

    final result = await repository.getDocumentStatus(1);
    expect(result.chatId, 123);
  });

  test('uploadFileでエラーだがdata["error"]がnull', () async {
    final mockFile = MultipartFile.fromBytes([1, 2, 3], filename: 'fail3.pdf');

    when(mockStorage.getAccessToken()).thenAnswer((_) async => 'token');

    when(
      mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/documents/upload'),
        statusCode: 400,
        data: {}, // errorがない
      ),
    );

    expect(
      () => repository.uploadFile(
        filePath: '/dummy/path/test.pdf',
        filename: 'fail3.pdf',
        fileType: 'pdf',
        multipartFileForTest: mockFile,
      ),
      throwsA(isA<HttpErrorException>()),
    );
  });

  test('refreshToken成功だがレスポンスボディが空で失敗', () async {
    dotenv.testLoad(fileInput: 'BASEURL=https://example.com');
    when(
      mockStorage.getRefreshToken(),
    ).thenAnswer((_) async => 'refresh_token');

    when(
      mockDio.post(
        '/tokens/renew_access',
        data: anyNamed('data'),
        options: anyNamed('options'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/tokens/renew_access'),
        statusCode: 200,
        data: {}, // 空データ
      ),
    );

    final result = await repository.refreshToken();
    expect(result, false); // UserResponse.fromJson で失敗することを期待
  });

  test('refreshTokenがdotenv BASEURL未設定で失敗', () async {
    dotenv.testLoad(fileInput: ''); // BASEURLなし

    // getRefreshToken のスタブを追加
    when(
      mockStorage.getRefreshToken(),
    ).thenAnswer((_) async => 'dummy_refresh_token');

    final result = await repository.refreshToken();

    expect(result, false); // BASEURLがnullなのでfalseになる想定
  });

  test('refreshTokenがnullで失敗', () async {
    dotenv.testLoad(fileInput: 'BASEURL=https://example.com');

    when(mockStorage.getRefreshToken()).thenAnswer((_) async => null);

    final result = await repository.refreshToken();
    expect(result, false);
  });

  test('リフレッシュトークンでも失敗する場合', () async {
    dotenv.testLoad(fileInput: 'BASEURL=https://example.com');
    final mockFile = MultipartFile.fromBytes([1, 2, 3], filename: 'fail2.pdf');

    when(mockStorage.getAccessToken()).thenAnswer((_) async => 'expired_token');

    // 最初の401
    when(
      mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/documents/upload'),
        statusCode: 401,
        data: {'error': 'unauthorized'},
      ),
    );

    // refresh token
    when(
      mockStorage.getRefreshToken(),
    ).thenAnswer((_) async => 'refresh_token');

    when(
      mockDio.post(
        '/tokens/renew_access',
        data: anyNamed('data'),
        options: anyNamed('options'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/tokens/renew_access'),
        statusCode: 401,
        data: {'error': 'unauthorized'},
      ),
    );

    expect(
      () => repository.uploadFile(
        filePath: '/dummy/path/test.pdf',
        filename: 'fail2.pdf',
        fileType: 'pdf',
        multipartFileForTest: mockFile,
      ),
      throwsA(isA<HttpErrorException>()),
    );
  });
}
