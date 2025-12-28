import 'package:freezed_annotation/freezed_annotation.dart';
part 'message.freezed.dart';
part 'message.g.dart';

@freezed
abstract class Message with _$Message {
  factory Message({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "session_id") required int sessionId,
    @JsonKey(name: "is_user") required bool isUser,
    @JsonKey(name: "message") required String message,
    @JsonKey(name: "created_at") required DateTime createdAt,
    
  }) = _Message;

  factory Message.typing() => Message(
        id: -1,
        sessionId: -1,
        isUser: false,
        message: "",
        createdAt: DateTime.now(),
      );

  factory Message.add({
    required int id,
    required int sessionId,
    required String message,
    required bool isUser,
    required DateTime createdAt,
  }) {
    return Message(
      id: id,
      sessionId: sessionId,
      isUser: isUser,
      message: message,
      createdAt: createdAt,
    );
  }

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
