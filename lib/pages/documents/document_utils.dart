import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:rag_faq_document/models/document/documents_response/documents_response.dart';
import 'package:rag_faq_document/pages/documents/documents_gridview_provider.dart';
import 'package:rag_faq_document/pages/home/home_provider.dart';

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

Future<void> refreshDocuments(WidgetRef ref) async {
  ref.invalidate(documentsGridviewProvider);
}

void showDocumentBottomSheet(
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
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
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
                _buildMenuTile(
                  icon: Icons.edit_outlined,
                  title: "編集",
                  subtitle: "ファイル名を変更",
                  onTap: () {
                    Navigator.pop(context);
                    showEditDocumentDialog(context, doc, ref);
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
                    showDeleteDocumentDialog(context, doc, ref);
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

void showEditDocumentDialog(
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
                  handleFileRename(
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
                handleFileRename(context, doc, newName + extension, ref);
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

void showDeleteDocumentDialog(
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
              handleFileDelete(context, doc, ref);
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

void handleFileRename(
  BuildContext context,
  DocumentsResponse doc,
  String newTitle,
  WidgetRef ref,
) {
  Navigator.of(context).pop();

  ref
      .read(documentsGridviewProvider.notifier)
      .editTitleDocument(newTitle: newTitle, documentId: doc.id);
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

Future<void> handleFileDelete(
  BuildContext context,
  DocumentsResponse doc,
  WidgetRef ref,
) async {
  Navigator.of(context).pop();
  final snackbar = ScaffoldMessenger.of(context);

  await ref.read(documentsGridviewProvider.notifier).deleteDocument(doc.id);
  ref.invalidate(chatListProvider);

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
