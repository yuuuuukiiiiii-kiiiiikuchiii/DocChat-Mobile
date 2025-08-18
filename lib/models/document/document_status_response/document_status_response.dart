import 'package:freezed_annotation/freezed_annotation.dart';
part 'document_status_response.freezed.dart';
part 'document_status_response.g.dart';
@freezed
abstract class DocumentStatusResponse with _$DocumentStatusResponse {
  factory DocumentStatusResponse({
    @JsonKey(name: "document_id") required int documentId,
    @JsonKey(name: "chat_id") int? chatId,
    @JsonKey(name: "filename") required String filename,
    @JsonKey(name: "status") required String status, 
  }) = _DocumentStatusResponse;

  factory DocumentStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$DocumentStatusResponseFromJson(json);
}

