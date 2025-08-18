import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
abstract class Profile with _$Profile {
  factory Profile({
    @JsonKey(name: "username") @Default('ユーザー名') String userName,
    @JsonKey(name: "email") @Default('user@example.com') String email,
    @JsonKey(name: "created_at")
    @Default("2024年1月1日")
     String createdAt,
    @JsonKey(name: "total_questions") @Default(0)  int totalQuestions,
    @JsonKey(name: "total_documents") @Default(0) int totalDocuments,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
