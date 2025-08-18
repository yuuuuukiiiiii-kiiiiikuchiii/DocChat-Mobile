// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_status_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DocumentStatusResponse {

@JsonKey(name: "document_id") int get documentId;@JsonKey(name: "chat_id") int? get chatId;@JsonKey(name: "filename") String get filename;@JsonKey(name: "status") String get status;
/// Create a copy of DocumentStatusResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentStatusResponseCopyWith<DocumentStatusResponse> get copyWith => _$DocumentStatusResponseCopyWithImpl<DocumentStatusResponse>(this as DocumentStatusResponse, _$identity);

  /// Serializes this DocumentStatusResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentStatusResponse&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentId,chatId,filename,status);

@override
String toString() {
  return 'DocumentStatusResponse(documentId: $documentId, chatId: $chatId, filename: $filename, status: $status)';
}


}

/// @nodoc
abstract mixin class $DocumentStatusResponseCopyWith<$Res>  {
  factory $DocumentStatusResponseCopyWith(DocumentStatusResponse value, $Res Function(DocumentStatusResponse) _then) = _$DocumentStatusResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "document_id") int documentId,@JsonKey(name: "chat_id") int? chatId,@JsonKey(name: "filename") String filename,@JsonKey(name: "status") String status
});




}
/// @nodoc
class _$DocumentStatusResponseCopyWithImpl<$Res>
    implements $DocumentStatusResponseCopyWith<$Res> {
  _$DocumentStatusResponseCopyWithImpl(this._self, this._then);

  final DocumentStatusResponse _self;
  final $Res Function(DocumentStatusResponse) _then;

/// Create a copy of DocumentStatusResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documentId = null,Object? chatId = freezed,Object? filename = null,Object? status = null,}) {
  return _then(_self.copyWith(
documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as int,chatId: freezed == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int?,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _DocumentStatusResponse implements DocumentStatusResponse {
   _DocumentStatusResponse({@JsonKey(name: "document_id") required this.documentId, @JsonKey(name: "chat_id") this.chatId, @JsonKey(name: "filename") required this.filename, @JsonKey(name: "status") required this.status});
  factory _DocumentStatusResponse.fromJson(Map<String, dynamic> json) => _$DocumentStatusResponseFromJson(json);

@override@JsonKey(name: "document_id") final  int documentId;
@override@JsonKey(name: "chat_id") final  int? chatId;
@override@JsonKey(name: "filename") final  String filename;
@override@JsonKey(name: "status") final  String status;

/// Create a copy of DocumentStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentStatusResponseCopyWith<_DocumentStatusResponse> get copyWith => __$DocumentStatusResponseCopyWithImpl<_DocumentStatusResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentStatusResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentStatusResponse&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentId,chatId,filename,status);

@override
String toString() {
  return 'DocumentStatusResponse(documentId: $documentId, chatId: $chatId, filename: $filename, status: $status)';
}


}

/// @nodoc
abstract mixin class _$DocumentStatusResponseCopyWith<$Res> implements $DocumentStatusResponseCopyWith<$Res> {
  factory _$DocumentStatusResponseCopyWith(_DocumentStatusResponse value, $Res Function(_DocumentStatusResponse) _then) = __$DocumentStatusResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "document_id") int documentId,@JsonKey(name: "chat_id") int? chatId,@JsonKey(name: "filename") String filename,@JsonKey(name: "status") String status
});




}
/// @nodoc
class __$DocumentStatusResponseCopyWithImpl<$Res>
    implements _$DocumentStatusResponseCopyWith<$Res> {
  __$DocumentStatusResponseCopyWithImpl(this._self, this._then);

  final _DocumentStatusResponse _self;
  final $Res Function(_DocumentStatusResponse) _then;

/// Create a copy of DocumentStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentId = null,Object? chatId = freezed,Object? filename = null,Object? status = null,}) {
  return _then(_DocumentStatusResponse(
documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as int,chatId: freezed == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int?,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
