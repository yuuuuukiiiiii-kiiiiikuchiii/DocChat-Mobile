import 'package:rag_faq_document/models/upload/upload.dart';
import 'package:rag_faq_document/services/upload/upload_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_screen_provider.g.dart';

@riverpod
class Upload extends _$Upload {
  @override
  FutureOr<UploadResponse?> build() {
    return null;
  }

  Future<void> upload({
    required String filePath,
    required String fileName,
    required String fileType,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return await ref
          .read(uploadServiceProvider)
          .uploadFile(filePath: filePath, fileName: fileName,fileType: fileType);
    });
  }
}
