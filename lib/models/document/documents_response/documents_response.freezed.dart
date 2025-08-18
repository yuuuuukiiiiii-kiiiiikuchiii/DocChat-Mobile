// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'documents_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DocumentsResponse {

 int get id; String get filename; String get filetype; String get fileurl;
/// Create a copy of DocumentsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentsResponseCopyWith<DocumentsResponse> get copyWith => _$DocumentsResponseCopyWithImpl<DocumentsResponse>(this as DocumentsResponse, _$identity);

  /// Serializes this DocumentsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentsResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.filetype, filetype) || other.filetype == filetype)&&(identical(other.fileurl, fileurl) || other.fileurl == fileurl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,filename,filetype,fileurl);

@override
String toString() {
  return 'DocumentsResponse(id: $id, filename: $filename, filetype: $filetype, fileurl: $fileurl)';
}


}

/// @nodoc
abstract mixin class $DocumentsResponseCopyWith<$Res>  {
  factory $DocumentsResponseCopyWith(DocumentsResponse value, $Res Function(DocumentsResponse) _then) = _$DocumentsResponseCopyWithImpl;
@useResult
$Res call({
 int id, String filename, String filetype, String fileurl
});




}
/// @nodoc
class _$DocumentsResponseCopyWithImpl<$Res>
    implements $DocumentsResponseCopyWith<$Res> {
  _$DocumentsResponseCopyWithImpl(this._self, this._then);

  final DocumentsResponse _self;
  final $Res Function(DocumentsResponse) _then;

/// Create a copy of DocumentsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? filename = null,Object? filetype = null,Object? fileurl = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,filetype: null == filetype ? _self.filetype : filetype // ignore: cast_nullable_to_non_nullable
as String,fileurl: null == fileurl ? _self.fileurl : fileurl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _DocumentsResponse implements DocumentsResponse {
   _DocumentsResponse({required this.id, required this.filename, required this.filetype, required this.fileurl});
  factory _DocumentsResponse.fromJson(Map<String, dynamic> json) => _$DocumentsResponseFromJson(json);

@override final  int id;
@override final  String filename;
@override final  String filetype;
@override final  String fileurl;

/// Create a copy of DocumentsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentsResponseCopyWith<_DocumentsResponse> get copyWith => __$DocumentsResponseCopyWithImpl<_DocumentsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentsResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.filetype, filetype) || other.filetype == filetype)&&(identical(other.fileurl, fileurl) || other.fileurl == fileurl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,filename,filetype,fileurl);

@override
String toString() {
  return 'DocumentsResponse(id: $id, filename: $filename, filetype: $filetype, fileurl: $fileurl)';
}


}

/// @nodoc
abstract mixin class _$DocumentsResponseCopyWith<$Res> implements $DocumentsResponseCopyWith<$Res> {
  factory _$DocumentsResponseCopyWith(_DocumentsResponse value, $Res Function(_DocumentsResponse) _then) = __$DocumentsResponseCopyWithImpl;
@override @useResult
$Res call({
 int id, String filename, String filetype, String fileurl
});




}
/// @nodoc
class __$DocumentsResponseCopyWithImpl<$Res>
    implements _$DocumentsResponseCopyWith<$Res> {
  __$DocumentsResponseCopyWithImpl(this._self, this._then);

  final _DocumentsResponse _self;
  final $Res Function(_DocumentsResponse) _then;

/// Create a copy of DocumentsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? filename = null,Object? filetype = null,Object? fileurl = null,}) {
  return _then(_DocumentsResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,filetype: null == filetype ? _self.filetype : filetype // ignore: cast_nullable_to_non_nullable
as String,fileurl: null == fileurl ? _self.fileurl : fileurl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
