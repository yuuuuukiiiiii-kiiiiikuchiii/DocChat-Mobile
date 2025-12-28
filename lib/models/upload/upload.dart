import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload.freezed.dart';
part 'upload.g.dart';

@freezed
abstract class UploadResponse with _$UploadResponse {
  factory UploadResponse({
    @JsonKey(name: "document_id") required int documentId,
    @JsonKey(name: "status") required String status,
    @JsonKey(name: "filename") required String filename,
  }) = _UploadResponse;

  factory UploadResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadResponseFromJson(json);
}



