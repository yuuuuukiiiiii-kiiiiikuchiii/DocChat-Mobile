// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_presign.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UploadPresign {

@JsonKey(name: "presigned_url") String get presignedUrl;@JsonKey(name: "object_key") String get objectKey;@JsonKey(name: "document_id") int get documentId;
/// Create a copy of UploadPresign
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadPresignCopyWith<UploadPresign> get copyWith => _$UploadPresignCopyWithImpl<UploadPresign>(this as UploadPresign, _$identity);

  /// Serializes this UploadPresign to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadPresign&&(identical(other.presignedUrl, presignedUrl) || other.presignedUrl == presignedUrl)&&(identical(other.objectKey, objectKey) || other.objectKey == objectKey)&&(identical(other.documentId, documentId) || other.documentId == documentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,presignedUrl,objectKey,documentId);

@override
String toString() {
  return 'UploadPresign(presignedUrl: $presignedUrl, objectKey: $objectKey, documentId: $documentId)';
}


}

/// @nodoc
abstract mixin class $UploadPresignCopyWith<$Res>  {
  factory $UploadPresignCopyWith(UploadPresign value, $Res Function(UploadPresign) _then) = _$UploadPresignCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "presigned_url") String presignedUrl,@JsonKey(name: "object_key") String objectKey,@JsonKey(name: "document_id") int documentId
});




}
/// @nodoc
class _$UploadPresignCopyWithImpl<$Res>
    implements $UploadPresignCopyWith<$Res> {
  _$UploadPresignCopyWithImpl(this._self, this._then);

  final UploadPresign _self;
  final $Res Function(UploadPresign) _then;

/// Create a copy of UploadPresign
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? presignedUrl = null,Object? objectKey = null,Object? documentId = null,}) {
  return _then(_self.copyWith(
presignedUrl: null == presignedUrl ? _self.presignedUrl : presignedUrl // ignore: cast_nullable_to_non_nullable
as String,objectKey: null == objectKey ? _self.objectKey : objectKey // ignore: cast_nullable_to_non_nullable
as String,documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UploadPresign implements UploadPresign {
   _UploadPresign({@JsonKey(name: "presigned_url") required this.presignedUrl, @JsonKey(name: "object_key") required this.objectKey, @JsonKey(name: "document_id") required this.documentId});
  factory _UploadPresign.fromJson(Map<String, dynamic> json) => _$UploadPresignFromJson(json);

@override@JsonKey(name: "presigned_url") final  String presignedUrl;
@override@JsonKey(name: "object_key") final  String objectKey;
@override@JsonKey(name: "document_id") final  int documentId;

/// Create a copy of UploadPresign
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadPresignCopyWith<_UploadPresign> get copyWith => __$UploadPresignCopyWithImpl<_UploadPresign>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UploadPresignToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadPresign&&(identical(other.presignedUrl, presignedUrl) || other.presignedUrl == presignedUrl)&&(identical(other.objectKey, objectKey) || other.objectKey == objectKey)&&(identical(other.documentId, documentId) || other.documentId == documentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,presignedUrl,objectKey,documentId);

@override
String toString() {
  return 'UploadPresign(presignedUrl: $presignedUrl, objectKey: $objectKey, documentId: $documentId)';
}


}

/// @nodoc
abstract mixin class _$UploadPresignCopyWith<$Res> implements $UploadPresignCopyWith<$Res> {
  factory _$UploadPresignCopyWith(_UploadPresign value, $Res Function(_UploadPresign) _then) = __$UploadPresignCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "presigned_url") String presignedUrl,@JsonKey(name: "object_key") String objectKey,@JsonKey(name: "document_id") int documentId
});




}
/// @nodoc
class __$UploadPresignCopyWithImpl<$Res>
    implements _$UploadPresignCopyWith<$Res> {
  __$UploadPresignCopyWithImpl(this._self, this._then);

  final _UploadPresign _self;
  final $Res Function(_UploadPresign) _then;

/// Create a copy of UploadPresign
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? presignedUrl = null,Object? objectKey = null,Object? documentId = null,}) {
  return _then(_UploadPresign(
presignedUrl: null == presignedUrl ? _self.presignedUrl : presignedUrl // ignore: cast_nullable_to_non_nullable
as String,objectKey: null == objectKey ? _self.objectKey : objectKey // ignore: cast_nullable_to_non_nullable
as String,documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
