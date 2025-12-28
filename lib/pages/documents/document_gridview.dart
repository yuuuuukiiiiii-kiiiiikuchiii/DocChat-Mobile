import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pdfx/pdfx.dart';
import 'package:rag_faq_document/models/document/documents_response/documents_response.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/pages/documents/document_utils.dart';
import 'package:rag_faq_document/pages/documents/documents_gridview_provider.dart';
import 'package:rag_faq_document/utils/error_dialog.dart';

class DocumentGridview extends ConsumerWidget {
  const DocumentGridview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(documentsGridviewProvider, (prev, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          if (!next.isLoading) {
            errorDialog(context, "データを取得失敗しました。", error as CustomError, null);
          }
        },
      );
    });

    final documents = ref.watch(documentsGridviewProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Documents")),
      body: documents.when(
        data: (data) {
          if (data.isEmpty) {
            return Center(child: Text("データがありません"));
          } else {
            return RefreshIndicator(
              onRefresh: () => refreshDocuments(ref),
              color: Colors.blue,
              backgroundColor: Colors.white,
              strokeWidth: 2.5,
              displacement: 40,
              child: SafeArea(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: (context, index) {
                    final doc = data[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DocumentViewerPage(
                                  fileType: doc.filetype,
                                  fileUrl: doc.fileurl,
                                  filename: doc.filename,
                                ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // サムネイル部分
                            Expanded(
                              flex: 4,
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[50],
                                ),
                                child: Stack(
                                  children: [
                                    // メインコンテンツ
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: Colors.grey[100],
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child:
                                            doc.filetype == 'image'
                                                ? Image.network(
                                                  doc.fileurl,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    return const Center(
                                                      child: Icon(
                                                        Icons.broken_image,
                                                        size: 40,
                                                        color: Colors.grey,
                                                      ),
                                                    );
                                                  },
                                                )
                                                : FutureBuilder<PdfPageImage>(
                                                  future: getPdfThumbnail(
                                                    doc.fileurl,
                                                  ),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                      );
                                                    } else if (snapshot
                                                            .hasError ||
                                                        !snapshot.hasData) {
                                                      return const Center(
                                                        child: Icon(
                                                          Icons.picture_as_pdf,
                                                          size: 40,
                                                          color: Colors.red,
                                                        ),
                                                      );
                                                    } else {
                                                      return Image.memory(
                                                        snapshot.data!.bytes,
                                                        fit: BoxFit.cover,
                                                      );
                                                    }
                                                  },
                                                ),
                                      ),
                                    ),
                                    // メニューボタン
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.more_vert),
                                          onPressed: () {
                                            showDocumentBottomSheet(
                                              context,
                                              doc,
                                              ref,
                                            );
                                          },
                                          iconSize: 18,
                                          color: Colors.grey[700],
                                          constraints: const BoxConstraints(
                                            minWidth: 32,
                                            minHeight: 32,
                                          ),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // ファイル情報部分
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  12,
                                  4,
                                  12,
                                  12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      doc.filename,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "iCloud Drive",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
        error: (error, stackTrace) {
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("データの取得に失敗しました。", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {
                      ref.invalidate(documentsGridviewProvider);
                    },
                    child: const Text("再度更新", style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),
          );
        },
        loading:
            () => Center(
              child: SpinKitFadingCircle(color: Colors.grey, size: 50.0),
            ),
      ),
    );
  }
}

class DocumentViewerPage extends StatelessWidget {
  final String fileType;
  final String fileUrl;
  final String filename;

  const DocumentViewerPage({
    super.key,
    required this.fileType,
    required this.fileUrl,
    required this.filename,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(filename)),
      body: Center(
        child:
            fileType == 'image'
                ? Image.network(fileUrl, fit: BoxFit.contain)
                : FutureBuilder<String>(
                  future: downloadFile(fileUrl, filename),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text('PDFの読み込みに失敗しました');
                    } else {
                      return PDFView(
                        autoSpacing: false,
                        filePath: snapshot.data!,
                        enableSwipe: true,
                        swipeHorizontal: false,
                      );
                    }
                  },
                ),
      ),
    );
  }
}
