import 'dart:io';

import 'package:rag_faq_document/services/upload/upload_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_screen_provider.g.dart';

@riverpod
class Upload extends _$Upload {
  @override
  FutureOr<int?> build() {
    return null;
  }

  Future<void> upload({
    required File filePath,
    required String fileName,
    required String mimeType,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return await ref
          .read(uploadServiceProvider)
          .newUpload(filePath: filePath, fileName: fileName, mimeType: mimeType);
    });
  }
}
