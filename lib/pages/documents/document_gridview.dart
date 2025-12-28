import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:rag_faq_document/models/document/documents_response/documents_response.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/pages/documents/documents_gridview_provider.dart';
import 'package:rag_faq_document/pages/home/home_provider.dart';
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
              onRefresh: () => _onRefresh(ref),
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
                                            // メニュー処理
                                            _showDocumentBottomSheet(
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

Future<String> downloadFile(String url, String filename) async {
  final response = await http.get(Uri.parse(url));
  final bytes = response.bodyBytes;
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}

Future<PdfPageImage> getPdfThumbnail(String url) async {
  final response = await http.get(Uri.parse(url));
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/temp_preview.pdf');
  await file.writeAsBytes(response.bodyBytes);

  final doc = await PdfDocument.openFile(file.path);
  final page = await doc.getPage(1);
  final image = await page.render(
    width: page.width,
    height: page.height,
    format: PdfPageImageFormat.png,
  );
  await page.close();
  await doc.close();
  return image!;
}

// リフレッシュ処理
Future<void> _onRefresh(WidgetRef ref) async {
  // プロバイダーを無効化して再取得
  ref.invalidate(documentsGridviewProvider);
}

// ボトムシートメニューの実装
void _showDocumentBottomSheet(
  BuildContext context,
  DocumentsResponse doc,
  WidgetRef ref,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ハンドルバー
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                // ファイル情報表示
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        doc.filetype == 'image'
                            ? Icons.image
                            : Icons.picture_as_pdf,
                        color:
                            doc.filetype == 'image' ? Colors.green : Colors.red,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc.filename,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            doc.filetype.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // メニュー項目
                _buildMenuTile(
                  icon: Icons.edit_outlined,
                  title: "編集",
                  subtitle: "ファイル名を変更",
                  onTap: () {
                    Navigator.pop(context);
                    _showEditDialog(context, doc, ref);
                  },
                ),

                const SizedBox(height: 8),

                _buildMenuTile(
                  icon: Icons.delete_outline,
                  title: "削除",
                  subtitle: "このファイルを削除",
                  textColor: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteDialog(context, doc, ref);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    },
  );
}

// メニューアイテムのウィジェット
Widget _buildMenuTile({
  required IconData icon,
  required String title,
  String? subtitle,
  required VoidCallback onTap,
  Color? textColor,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (textColor ?? Colors.grey).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: textColor ?? Colors.grey[700], size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor ?? Colors.black87,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    ),
  );
}

// 編集ダイアログの実装
void _showEditDialog(
  BuildContext context,
  DocumentsResponse doc,
  WidgetRef ref,
) {
  final TextEditingController controller = TextEditingController();
  final String originalName = doc.filename;
  final String extension =
      originalName.contains('.') ? '.${originalName.split('.').last}' : '';
  final String nameWithoutExtension =
      originalName.contains('.')
          ? originalName.substring(0, originalName.lastIndexOf('.'))
          : originalName;

  controller.text = nameWithoutExtension;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "ファイル名を編集",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "新しいファイル名を入力してください",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "ファイル名",
                suffix: Text(
                  extension,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
              ),
              maxLength: 100,
              textInputAction: TextInputAction.done,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _handleFileRename(
                    context,
                    doc,
                    value.trim() + extension,
                    ref,
                  );
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "キャンセル",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                _handleFileRename(context, doc, newName + extension, ref);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("保存", style: TextStyle(fontSize: 16)),
          ),
        ],
      );
    },
  );
}

// 削除確認ダイアログの実装
void _showDeleteDialog(
  BuildContext context,
  DocumentsResponse doc,
  WidgetRef ref,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "ファイルを削除",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("このファイルを削除しますか？", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    doc.filetype == 'image'
                        ? Icons.image
                        : Icons.picture_as_pdf,
                    color: doc.filetype == 'image' ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      doc.filename,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "この操作は取り消せません。",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "キャンセル",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _handleFileDelete(context, doc, ref);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("削除", style: TextStyle(fontSize: 16)),
          ),
        ],
      );
    },
  );
}

// ファイル名変更の処理
void _handleFileRename(
  BuildContext context,
  DocumentsResponse doc,
  String newTitle,
  WidgetRef ref,
) {
  Navigator.of(context).pop(); // ダイアログを閉じる

  // TODO: 実際のファイル名変更APIを呼び出す

  ref
      .read(documentsGridviewProvider.notifier)
      .editTitleDocument(newTitle: newTitle, documentId: doc.id);
  ref.invalidate(chatListProvider);
  // 成功メッセージ表示
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("ファイル名を「$newTitle」に変更しました"),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

// ファイル削除の処理
void _handleFileDelete(
  BuildContext context,
  DocumentsResponse doc,
  WidgetRef ref,
) async {
  Navigator.of(context).pop(); // ダイアログを閉じる
  final snackbar = ScaffoldMessenger.of(context);

  // TODO: 実際のファイル削除APIを呼び出す
  await ref.read(documentsGridviewProvider.notifier).deleteDocument(doc.id);
  ref.invalidate(chatListProvider);

  // 成功メッセージ表示
  snackbar.showSnackBar(
    SnackBar(
      content: Text("「${doc.filename}」を削除しました"),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
