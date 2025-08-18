import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pdfx/pdfx.dart';
import 'package:rag_faq_document/config/router/route_names.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/services/upload/upload_service_provider.dart';
import 'package:rag_faq_document/utils/error_dialog.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  final int documentId;
  final String filePath; // ← アップロードしたファイルのパスを受け取る
  final String fileType; // ← 'pdf' または 'image'
  const LoadingScreen({
    super.key,
    required this.documentId,
    required this.filePath,
    required this.fileType,
  });

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen>
    with SingleTickerProviderStateMixin {
  Timer? timer;
  late AnimationController _controller;
  late Animation<double> _animation;
  PdfPageImage? _pdfPageImage;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true); // ← 大小を繰り返す

    _animation = Tween<double>(
      begin: 0.85,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // PDF読み込み
    if (widget.fileType == 'pdf') {
      _loadPdfPageAsImage();
    }

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkgetDocumentStatus();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadPdfPageAsImage() async {
    final doc = await PdfDocument.openFile(widget.filePath);
    final page = await doc.getPage(1);
    final image = await page.render(
      width: page.width,
      height: page.height,
      format: PdfPageImageFormat.png,
    );
    await page.close();
    setState(() {
      _pdfPageImage = image;
    });
  }

  Future<void> checkgetDocumentStatus() async {
    final goRouter = GoRouter.of(context);

    try {
      final data = await ref
          .read(uploadServiceProvider)
          .getDocumentStatus(widget.documentId);

      final status = data.status;
      final chatId = data.chatId;
      final title = data.filename;
      final documentId =data.documentId;

      if (status == "completed") {
        timer?.cancel();

        goRouter.goNamed(
          RouteNames.chat,
          extra: {"title": title, "chatId": chatId,"documentId":documentId},
        );
      } else if (status == "failed") {
        timer?.cancel();

        _showError(message: "ドキュメントの処理に失敗しました。", goTo: RouteNames.upload);
      }
      // processing の場合は何もしない（継続）
    } on CustomError catch (e) {
      timer?.cancel();
      _showError(message: "ステータス取得に失敗しました。", error: e, goTo: RouteNames.upload);
    }
  }

  Future<void> _cancelProcessing() async {
    try {
      await ref.read(uploadServiceProvider).cancelUpload(widget.documentId);

      timer?.cancel();
      _controller.stop();

      // アップロード画面に戻す or 任意の場所へ遷移
      if (mounted) {
        context.goNamed(RouteNames.upload);
      }
    } on CustomError catch (e) {
      _showError(message: "キャンセルに失敗しました", error: e);
    }
  }

  void _showError({required String message, CustomError? error, String? goTo}) {
    final customError = error ?? CustomError.unknown(message: message);
    errorDialog(context, message, customError, goTo);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          // 背景アニメーション
          Lottie.asset(
            'assets/lottie/load_bg.json',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 18),
                // アニメーション付き画像プレビュー
                //if (widget.fileType == 'image')
                ScaleTransition(
                  scale: _animation,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: screenWidth * 0.9,
                      color:
                          widget.fileType == 'image'
                              ? Colors.white
                              : const Color(0xFFEFEFEF), // PDF用に薄いグレー
                      padding: const EdgeInsets.all(8), // 余白も少し入れると良い
                      child:
                          widget.fileType == 'image'
                              ? Image.file(
                                File(widget.filePath),
                                fit: BoxFit.contain,
                              )
                              : _pdfPageImage != null
                              ? Image.memory(
                                _pdfPageImage!.bytes,
                                fit: BoxFit.contain,
                              )
                              : const SizedBox(
                                width: 200,
                                height: 200,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),
                SpinKitFadingCircle(color: Colors.grey, size: 50.0),
                SizedBox(height: 18),
                Text(
                  'ドキュメントを分析中...',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text(
                  'しばらくお待ちください',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () async {
                    await _cancelProcessing();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFFFF4D8D),
                  ),
                  child: Text('キャンセル'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
