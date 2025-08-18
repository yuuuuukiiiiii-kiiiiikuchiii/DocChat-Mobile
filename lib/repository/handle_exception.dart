import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rag_faq_document/models/error/custom_error.dart';



CustomError handleException(Object e) {
  print('🔍 handleException() called with $e (${e.runtimeType})');

  if (e is SocketException || e.toString().contains('SocketException')) {
    print('🔍 Detected SocketException');
    return CustomError.network(message: 'ネットワークに接続できません。接続を確認してください。');
  } else if (e is TimeoutException) {
    print('🔍 Detected TimeoutException');
    return CustomError.timeout(message: 'リクエストがタイムアウトしました。時間を置いて再試行してください。');
  } else if (e is http.ClientException ||
      e.toString().contains("Connection reset by peer") ||
      e.toString().contains("Connection refused")) {
    print('🔍 Detected ClientException with connection issue');
    return CustomError.network(message: 'ネットワークに接続できません。接続を確認してください。');
  } else {
    print('⚠️ Detected Unknown Error');
    return CustomError.unknown(message: "不明なエラー: ${e.toString()}");
  }
}
