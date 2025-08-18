import 'package:rag_faq_document/models/document/documents_response/documents_response.dart';
import 'package:rag_faq_document/services/document/doc_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'documents_gridview_provider.g.dart';

@riverpod
class DocumentsGridview extends _$DocumentsGridview {
  @override
  FutureOr<List<DocumentsResponse>> build() {
    return fetchDocuments();
  }

  Future<List<DocumentsResponse>> fetchDocuments() async {
    return await ref.read(docServiceProvider).listDocument();
  }

  Future<void> editTitleDocument({
    required String newTitle,
    required int documentId,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref
          .read(docServiceProvider)
          .editTitleDocument(newTitle: newTitle, documentId: documentId);
      return [
        for (final doc in state.value!)
          if (doc.id == documentId) doc.copyWith(filename: newTitle) else doc,
      ];
    });
  }

  Future<void> deleteDocument(int documentId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(docServiceProvider).deleteDocument(documentId);

      return [
        for (final doc in state.value!)
          if (documentId != doc.id) doc,
      ];
    });
  }
}
