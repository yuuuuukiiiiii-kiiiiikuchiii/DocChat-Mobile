import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_presign.freezed.dart';
part 'upload_presign.g.dart';

@freezed
abstract class UploadPresign with _$UploadPresign {
  factory UploadPresign({
    @JsonKey(name: "presigned_url") required String presignedUrl,
    @JsonKey(name: "object_key") required String objectKey,
    @JsonKey(name: "document_id") required int documentId,
  }) = _UploadPresign;

  factory UploadPresign.fromJson(Map<String, dynamic> json) =>
      _$UploadPresignFromJson(json);
}
