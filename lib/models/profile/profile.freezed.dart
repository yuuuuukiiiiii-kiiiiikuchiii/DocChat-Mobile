// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Profile {

@JsonKey(name: "username") String get userName;@JsonKey(name: "email") String get email;@JsonKey(name: "created_at") String get createdAt;@JsonKey(name: "total_questions") int get totalQuestions;@JsonKey(name: "total_documents") int get totalDocuments;
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCopyWith<Profile> get copyWith => _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Profile&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.email, email) || other.email == email)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.totalDocuments, totalDocuments) || other.totalDocuments == totalDocuments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userName,email,createdAt,totalQuestions,totalDocuments);

@override
String toString() {
  return 'Profile(userName: $userName, email: $email, createdAt: $createdAt, totalQuestions: $totalQuestions, totalDocuments: $totalDocuments)';
}


}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res>  {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) = _$ProfileCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "username") String userName,@JsonKey(name: "email") String email,@JsonKey(name: "created_at") String createdAt,@JsonKey(name: "total_questions") int totalQuestions,@JsonKey(name: "total_documents") int totalDocuments
});




}
/// @nodoc
class _$ProfileCopyWithImpl<$Res>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userName = null,Object? email = null,Object? createdAt = null,Object? totalQuestions = null,Object? totalDocuments = null,}) {
  return _then(_self.copyWith(
userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,totalDocuments: null == totalDocuments ? _self.totalDocuments : totalDocuments // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Profile implements Profile {
   _Profile({@JsonKey(name: "username") this.userName = 'ユーザー名', @JsonKey(name: "email") this.email = 'user@example.com', @JsonKey(name: "created_at") this.createdAt = "2024年1月1日", @JsonKey(name: "total_questions") this.totalQuestions = 0, @JsonKey(name: "total_documents") this.totalDocuments = 0});
  factory _Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

@override@JsonKey(name: "username") final  String userName;
@override@JsonKey(name: "email") final  String email;
@override@JsonKey(name: "created_at") final  String createdAt;
@override@JsonKey(name: "total_questions") final  int totalQuestions;
@override@JsonKey(name: "total_documents") final  int totalDocuments;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCopyWith<_Profile> get copyWith => __$ProfileCopyWithImpl<_Profile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Profile&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.email, email) || other.email == email)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.totalDocuments, totalDocuments) || other.totalDocuments == totalDocuments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userName,email,createdAt,totalQuestions,totalDocuments);

@override
String toString() {
  return 'Profile(userName: $userName, email: $email, createdAt: $createdAt, totalQuestions: $totalQuestions, totalDocuments: $totalDocuments)';
}


}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) = __$ProfileCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "username") String userName,@JsonKey(name: "email") String email,@JsonKey(name: "created_at") String createdAt,@JsonKey(name: "total_questions") int totalQuestions,@JsonKey(name: "total_documents") int totalDocuments
});




}
/// @nodoc
class __$ProfileCopyWithImpl<$Res>
    implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userName = null,Object? email = null,Object? createdAt = null,Object? totalQuestions = null,Object? totalDocuments = null,}) {
  return _then(_Profile(
userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,totalDocuments: null == totalDocuments ? _self.totalDocuments : totalDocuments // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
