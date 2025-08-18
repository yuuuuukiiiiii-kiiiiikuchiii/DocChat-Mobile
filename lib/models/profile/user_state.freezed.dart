// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserState {

 String get userName; String get email; String get createdAt; int get totalQuestions; int get totalDocuments;
/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserStateCopyWith<UserState> get copyWith => _$UserStateCopyWithImpl<UserState>(this as UserState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserState&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.email, email) || other.email == email)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.totalDocuments, totalDocuments) || other.totalDocuments == totalDocuments));
}


@override
int get hashCode => Object.hash(runtimeType,userName,email,createdAt,totalQuestions,totalDocuments);

@override
String toString() {
  return 'UserState(userName: $userName, email: $email, createdAt: $createdAt, totalQuestions: $totalQuestions, totalDocuments: $totalDocuments)';
}


}

/// @nodoc
abstract mixin class $UserStateCopyWith<$Res>  {
  factory $UserStateCopyWith(UserState value, $Res Function(UserState) _then) = _$UserStateCopyWithImpl;
@useResult
$Res call({
 String userName, String email, String createdAt, int totalQuestions, int totalDocuments
});




}
/// @nodoc
class _$UserStateCopyWithImpl<$Res>
    implements $UserStateCopyWith<$Res> {
  _$UserStateCopyWithImpl(this._self, this._then);

  final UserState _self;
  final $Res Function(UserState) _then;

/// Create a copy of UserState
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


class _UserState implements UserState {
   _UserState({required this.userName, required this.email, required this.createdAt, required this.totalQuestions, required this.totalDocuments});
  

@override final  String userName;
@override final  String email;
@override final  String createdAt;
@override final  int totalQuestions;
@override final  int totalDocuments;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserStateCopyWith<_UserState> get copyWith => __$UserStateCopyWithImpl<_UserState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserState&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.email, email) || other.email == email)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.totalDocuments, totalDocuments) || other.totalDocuments == totalDocuments));
}


@override
int get hashCode => Object.hash(runtimeType,userName,email,createdAt,totalQuestions,totalDocuments);

@override
String toString() {
  return 'UserState(userName: $userName, email: $email, createdAt: $createdAt, totalQuestions: $totalQuestions, totalDocuments: $totalDocuments)';
}


}

/// @nodoc
abstract mixin class _$UserStateCopyWith<$Res> implements $UserStateCopyWith<$Res> {
  factory _$UserStateCopyWith(_UserState value, $Res Function(_UserState) _then) = __$UserStateCopyWithImpl;
@override @useResult
$Res call({
 String userName, String email, String createdAt, int totalQuestions, int totalDocuments
});




}
/// @nodoc
class __$UserStateCopyWithImpl<$Res>
    implements _$UserStateCopyWith<$Res> {
  __$UserStateCopyWithImpl(this._self, this._then);

  final _UserState _self;
  final $Res Function(_UserState) _then;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userName = null,Object? email = null,Object? createdAt = null,Object? totalQuestions = null,Object? totalDocuments = null,}) {
  return _then(_UserState(
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
