import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rag_faq_document/config/router/route_names.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/models/message/message.dart';
import 'package:rag_faq_document/pages/chat/chat_screen_provider.dart';
import 'package:rag_faq_document/pages/widgets/message_card.dart';
import 'package:rag_faq_document/utils/error_dialog.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String documentTitle;
  final int documentId;
  final int chatId;

  const ChatScreen({
    super.key,
    required this.documentTitle,
    required this.documentId,
    required this.chatId,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.hasContentDimensions) {
        final distance =
            (_scrollController.position.maxScrollExtent -
                    _scrollController.position.pixels)
                .abs();

        if (distance < 200) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        } else {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      } else {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });
  }

  void _handleSubmitted(String message) {
    _textController.clear();
    setState(() {
      ref
          .read(chatScreenProvider(widget.chatId).notifier)
          .postMessage(
            message: message,
            sessionId: widget.chatId,
            documentId: widget.documentId,
            title: widget.documentTitle,
          );
      _isTyping = true;
    });
    _scrollToBottom();
  }

  // 近いときだけ自動スクロール（reverse:true の場合は minScrollExtent が“下端”）
void _maybeAutoScrollToBottom() {
  if (!_scrollController.hasClients) return;
  final atBottom = _scrollController.position.pixels
      <= _scrollController.position.minScrollExtent + 80; // 80px 以内なら最下部扱い
  if (atBottom) {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<Message>>>(chatScreenProvider(widget.chatId), (
      previus,
      next,
    ) {
      next.whenOrNull(
        data: (data) {
          setState(() {
            _isTyping = false;
            _scrollToBottom();
          });
        },
        error: (error, stackTrace) {
          if (!next.isLoading) {
            errorDialog(context, "データの取得に失敗しました。", error as CustomError, null);
          }
        },
      );
    });
    final messageListState = ref.watch(chatScreenProvider(widget.chatId));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).goNamed(RouteNames.home),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: messageListState.when(
                data: (List<Message> data) {
                  final List<Message> displayedMessages = [...data];

                  if (_isTyping) {
                    displayedMessages.add(Message.typing());
                  }

                  return ListView.builder(
                    
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: displayedMessages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final msg = displayedMessages[index];

                      // 最後の要素かつ isTyping = true なら「考え中...」
                      final isLast = index == displayedMessages.length - 1;
                      if (_isTyping && isLast) {
                        return _buildTypingIndicator();
                      }

                      if (msg.isUser) {
                        return MyMessageCard(
                          message: msg.message,
                          date: DateFormat('yyyy/MM/dd HH:mm').format(msg.createdAt.toLocal()),
                        );
                      } else {
                        return SenderMessageCard(
                          message: msg.message,
                          date: DateFormat('yyyy/MM/dd HH:mm').format(msg.createdAt.toLocal()),
                        );
                      }
                    },
                  );
                },
                error: (error, stackTrace) {
                  return SizedBox.shrink();
                },
                loading: () {
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Color.fromRGBO(19, 28, 33, 1)),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
              ),
            ),
            SizedBox(width: 8),
            Text('考え中...', style: TextStyle(color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: _textController,
                onSubmitted: (v) {
                  final t = v.trim();
                  if (t.isNotEmpty) _handleSubmitted(t);
                },
                decoration: InputDecoration(
                  hintText: 'このドキュメントについて質問する...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),

            // ← ここだけ監視して差し替える
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _textController,
              builder: (context, value, _) {
                final canSend = value.text.trim().isNotEmpty;
                return Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      42,
                      204,
                      166,
                    ).withValues(alpha:canSend ? 1.0 : 0.4), // 見た目も薄く
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.white,
                    onPressed:
                        canSend
                            ? () =>
                                _handleSubmitted(_textController.text.trim())
                            : null, // ← nullで無効化
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
