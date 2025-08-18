import 'package:freezed_annotation/freezed_annotation.dart';

part 'documents_response.freezed.dart';
part 'documents_response.g.dart';

@freezed
abstract class DocumentsResponse with _$DocumentsResponse {

  factory DocumentsResponse({
    required int id,
    required String filename,
    required String filetype,
    required String fileurl, 
  }) = _DocumentsResponse;

  factory DocumentsResponse.fromJson(Map<String, dynamic> json) => _$DocumentsResponseFromJson(json);
}