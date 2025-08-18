import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
abstract class Chat with _$Chat {
  factory Chat({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "user_id") required int userId,
    @JsonKey(name: "document_id") required int documentId,
    @JsonKey(name: "title") required String title,
    @JsonKey(name: "created_at") required DateTime createdAt,
    @JsonKey(name: "updated_at") required DateTime updatedAt,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}




