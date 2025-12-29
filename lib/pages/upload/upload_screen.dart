import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mime/mime.dart';
import 'package:rag_faq_document/config/router/route_names.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/pages/upload/upload_screen_provider.dart';
import 'package:rag_faq_document/utils/error_dialog.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  String? _filePath;
  String? _fileName;
  String? _mimeType;
  File? _selectedFile;

  //編集ダイアログの実装
  void _showEditDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    if (_fileName == null) return;
    final String originalName = _fileName!;
    final String extension =
        originalName.contains('.') ? '.${originalName.split('.').last}' : '';
    final String nameWithoutExtension =
        originalName.contains('.')
            ? originalName.substring(0, originalName.lastIndexOf('.'))
            : originalName;

    controller.text = nameWithoutExtension;
    // ✅ すべて選択（selectAll）
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: nameWithoutExtension.length,
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                    _handleFileRename(context, value.trim() + extension);
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
                  _handleFileRename(context, newName + extension);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text("保存", style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  // ファイル名変更の処理
  void _handleFileRename(BuildContext context, String newTitle) {
    Navigator.of(context).pop(); // ダイアログを閉じる

    setState(() {
      _fileName = newTitle; // 🔄 ファイル名を更新
    });
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

  // PDFファイルを選択
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (!mounted) return; // ✅ context 使用前に必ずチェック

      if (result != null && result.files.first.path != null) {
        final path = result.files.first.path!;
        final name = result.files.first.name;
        final file = File(path);

        setState(() {
          _selectedFile = file;
          _filePath = path;
          _fileName = name;
          _mimeType = lookupMimeType(path);
        });

        //_showSnackBar('ファイルの読み込みに成功しました', isError: false);
        _showEditDialog(context);
      } else {
        _showSnackBar('ファイルの読み込みに失敗しました', isError: true);
      }
    } catch (e) {
      if (!mounted) return;

      _showSnackBar('エラーが発生しました: $e', isError: true);
    }
  }

  // 画像を選択（ギャラリーから）
  // Future<void> _pickImage() async {
  //   try {
  //     final ImagePicker imagePicker = ImagePicker();
  //     final XFile? image = await imagePicker.pickImage(
  //       source: ImageSource.gallery,
  //       imageQuality: 100, // 高品質の画像を使用
  //     );

  //     if (!mounted) return; // ✅ context 使用前に必ずチェック

  //     if (image != null) {
  //       final file = File(image.path);
  //       final path = image.path;
  //       final name = image.name;
  //       setState(() {
  //         _selectedFile = file;
  //         _filePath = path;
  //         _fileName = name;
  //         _mimeType = lookupMimeType(path);
  //       });
  //       //_showSnackBar('画像の読み込みに成功しました', isError: false);
  //       _showEditDialog(context);
  //     } else {
  //       _showSnackBar('画像の読み込みに失敗しました', isError: true);
  //     }
  //   } catch (e) {
  //     if (!mounted) return;

  //     _showSnackBar('エラーが発生しました: $e', isError: true);
  //   }
  // }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _submit() async {
    if (_filePath != null &&
        _fileName != null &&
        _mimeType != null &&
        _selectedFile != null) {
      await ref
          .read(uploadProvider.notifier)
          .upload(
            filePath: _selectedFile!,
            fileName: _fileName!,
            mimeType: _mimeType!,
          );
    } else {
      errorDialog(
        context,
        "ファイルまたはタイトルが未選択です",
        CustomError.unknown(message: "アップロードに必要な情報が不足しています"),
        null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(uploadProvider);

    ref.listen<AsyncValue>(uploadProvider, (prev, next) {
      next.whenOrNull(
        data: (data) {
          final int documentId = data.documentId;
          final String status = data.status;
          if (status == "processing") {
            GoRouter.of(context).goNamed(
              RouteNames.loading,
              extra: {
                "documentId": documentId,
                "filePath": _filePath,
                "fileType": _mimeType,
              },
            );
          }
        },
        error:
            (error, stackTrace) => errorDialog(
              context,
              "ファイルの読み込みに失敗しました。",
              error as CustomError,
              null,
            ),
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 48),
                  Center(
                    child: Text(
                      'アップロードするファイルを選択してください',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildUploadOption(context, Icons.folder, 'デバイス'),
                      //_buildUploadOption(context, Icons.image, 'ギャラリー'),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildPreviewWidget(),
                  SizedBox(height: 16),
                  if (_fileName != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.insert_drive_file,
                                color: Colors.blueAccent,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _fileName!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis, // 長い場合は「...」
                                  maxLines: 2, // 最大2行まで表示
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed:
                                    () => _showEditDialog(context), // 名前変更
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  SizedBox(height: 16),
                  // 送信ボタン
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: uploadState.maybeWhen(
                        loading: () => null,
                        orElse: () => _submit,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 42, 204, 166),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: Color.fromARGB(
                          255,
                          42,
                          204,
                          166,
                        ).withValues(alpha: 0.5),
                      ),
                      child: Text(
                        style: TextStyle(fontSize: 16),
                        uploadState.maybeWhen(
                          loading: () => '通信中...',
                          orElse: () => 'アップロード',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 4,
              child: IconButton(
                iconSize: 28,
                icon: const Icon(Icons.arrow_back),
                onPressed: () => GoRouter.of(context).goNamed(RouteNames.home),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOption(BuildContext context, IconData icon, String label) {
    return InkWell(
      onTap: () {
        switch (label) {
          case 'デバイス':
            _pickFile();
            break;
          case 'ギャラリー':
            //_pickImage();
            break;
        }
      },
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(16),
              child: Icon(icon, size: 36, color: Color(0xFF5C7CFA)),
            ),
            SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewWidget() {
    if (_filePath == null) return Container();

    if (_mimeType == 'image/jpeg' || _mimeType == 'image/png') {
      return SizedBox(
        height: 350,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(File(_filePath!), fit: BoxFit.contain),
        ),
      );
    } else if (_mimeType == 'application/pdf') {
      return Center(
        child: Container(
          height: 350,
          width: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: PDFView(key: ValueKey(_filePath), filePath: _filePath!),
        ),
      );
    }
    return Container();
  }
}
