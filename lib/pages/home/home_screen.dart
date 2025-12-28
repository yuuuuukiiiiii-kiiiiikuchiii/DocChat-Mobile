import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:rag_faq_document/config/router/route_names.dart';
import 'package:rag_faq_document/models/chat/chat.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/pages/home/home_provider.dart';
import 'package:rag_faq_document/utils/error_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  Widget prevTodosWidget = const SizedBox.shrink();
  int _currentPage = 1;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    final maxScroll = position.maxScrollExtent;
    final currentScroll = position.pixels;
    final threshold = maxScroll - 200.0;

    if (currentScroll >= threshold && !_isFetchingMore) {
      _isFetchingMore = true;
      ref.read(chatListProvider.notifier).addChats(_currentPage + 1).then((_) {
        Future.delayed(const Duration(milliseconds: 3000), () {
          if (mounted) {
            setState(() {
              _currentPage++;
              _isFetchingMore = false;
            });
          }
        });
      });
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _currentPage = 1; // 現在ページ番号をリセット
      _isFetchingMore = false; // ローディング状態もリセット
    });

    //ref.read(chatListProvider.notifier).reset(); // hasMore フラグをリセット
    ref.invalidate(chatListProvider); // データ再取得
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(chatListProvider);

    ref.listen<AsyncValue<List<Chat>>>(chatListProvider, (previus, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          if (!next.isLoading) {
            final err = error as CustomError;
            return errorDialog(context, err.message, err, null);
          }
        },
      );
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'DocChat',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Lottie.asset('assets/lottie/logo2.json', height: 150),
              ),
              const SizedBox(height: 16),
              // アップロードボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file),
                  label: const Text(
                    'ドキュメントをアップロード',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    GoRouter.of(context).pushNamed(RouteNames.upload);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 42, 204, 166),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                '最近のドキュメント',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),

              // ドキュメント一覧（スクロール可能）
              Expanded(
                child: homeState.when(
                  skipError: true,
                  data: (List<Chat> allChats) {
                    if (allChats.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: ListView(
                          // 中身がなくてもスクロール可能にする
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 200), // なくてもOK。見た目の余白が欲しければ入れる
                            Center(
                              child: Text(
                                "データがありません",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    prevTodosWidget = RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: Colors.blue,
                      backgroundColor: Colors.white,
                      strokeWidth: 2.5,
                      displacement: 40,
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        thickness: 8,
                        radius: const Radius.circular(4),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _scrollController,
                          itemCount:
                              allChats.length + (_isFetchingMore ? 1 : 0),

                          itemBuilder: (context, index) {
                            if (index == allChats.length && _isFetchingMore) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: SpinKitFadingCircle(
                                    color: Colors.grey,
                                    size: 50.0,
                                  ),
                                ),
                              );
                            }
                            final chat = allChats[index];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _buildDocumentCard(
                                context,
                                chat.title,
                                _formatUploadedAt(chat.updatedAt),
                                chatId: chat.id,
                                documentId: chat.documentId,
                              ),
                            );
                          },
                        ),
                      ),
                    );

                    return prevTodosWidget;
                  },
                  error: (error, stackTrace) {
                    final err = error as CustomError;
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            err.userMessage,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          OutlinedButton(
                            onPressed: () {
                              ref.invalidate(chatListProvider);
                            },
                            child: const Text(
                              "再度取得",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () {
                    return prevTodosWidget;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildDocumentCard(
  BuildContext context,
  String title,
  String subtitle, {
  required int chatId,
  required int documentId,
}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ), // 👈 高さと横幅
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12)),
      onTap: () {
        GoRouter.of(context).goNamed(
          RouteNames.chat,
          extra: {"title": title, "chatId": chatId, "documentId": documentId},
        );
      },
      trailing: Column(children: [Icon(Icons.chevron_right)]),
    ),
  );
}

String _formatUploadedAt(DateTime time) {
  final now = DateTime.now();
  final diff = now.difference(time);

  if (diff.inMinutes < 60) return "${diff.inMinutes}分前にアップロード";
  if (diff.inHours < 24) return "${diff.inHours}時間前にアップロード";
  if (diff.inDays == 1) return "昨日アップロード";
  return "${diff.inDays}日前にアップロード";
}
