// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TokenModel {

 String? get accessToken; DateTime? get accessTokenExpiresAt; String? get refreshToken; DateTime? get refreshTokenExpiresAt; bool get firstLaunchCompleted;
/// Create a copy of TokenModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenModelCopyWith<TokenModel> get copyWith => _$TokenModelCopyWithImpl<TokenModel>(this as TokenModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenModel&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.accessTokenExpiresAt, accessTokenExpiresAt) || other.accessTokenExpiresAt == accessTokenExpiresAt)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.refreshTokenExpiresAt, refreshTokenExpiresAt) || other.refreshTokenExpiresAt == refreshTokenExpiresAt)&&(identical(other.firstLaunchCompleted, firstLaunchCompleted) || other.firstLaunchCompleted == firstLaunchCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,accessToken,accessTokenExpiresAt,refreshToken,refreshTokenExpiresAt,firstLaunchCompleted);

@override
String toString() {
  return 'TokenModel(accessToken: $accessToken, accessTokenExpiresAt: $accessTokenExpiresAt, refreshToken: $refreshToken, refreshTokenExpiresAt: $refreshTokenExpiresAt, firstLaunchCompleted: $firstLaunchCompleted)';
}


}

/// @nodoc
abstract mixin class $TokenModelCopyWith<$Res>  {
  factory $TokenModelCopyWith(TokenModel value, $Res Function(TokenModel) _then) = _$TokenModelCopyWithImpl;
@useResult
$Res call({
 String? accessToken, DateTime? accessTokenExpiresAt, String? refreshToken, DateTime? refreshTokenExpiresAt, bool firstLaunchCompleted
});




}
/// @nodoc
class _$TokenModelCopyWithImpl<$Res>
    implements $TokenModelCopyWith<$Res> {
  _$TokenModelCopyWithImpl(this._self, this._then);

  final TokenModel _self;
  final $Res Function(TokenModel) _then;

/// Create a copy of TokenModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = freezed,Object? accessTokenExpiresAt = freezed,Object? refreshToken = freezed,Object? refreshTokenExpiresAt = freezed,Object? firstLaunchCompleted = null,}) {
  return _then(_self.copyWith(
accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,accessTokenExpiresAt: freezed == accessTokenExpiresAt ? _self.accessTokenExpiresAt : accessTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,refreshTokenExpiresAt: freezed == refreshTokenExpiresAt ? _self.refreshTokenExpiresAt : refreshTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,firstLaunchCompleted: null == firstLaunchCompleted ? _self.firstLaunchCompleted : firstLaunchCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc


class _TokenModel implements TokenModel {
   _TokenModel({this.accessToken, this.accessTokenExpiresAt, this.refreshToken, this.refreshTokenExpiresAt, this.firstLaunchCompleted = false});
  

@override final  String? accessToken;
@override final  DateTime? accessTokenExpiresAt;
@override final  String? refreshToken;
@override final  DateTime? refreshTokenExpiresAt;
@override@JsonKey() final  bool firstLaunchCompleted;

/// Create a copy of TokenModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokenModelCopyWith<_TokenModel> get copyWith => __$TokenModelCopyWithImpl<_TokenModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenModel&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.accessTokenExpiresAt, accessTokenExpiresAt) || other.accessTokenExpiresAt == accessTokenExpiresAt)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.refreshTokenExpiresAt, refreshTokenExpiresAt) || other.refreshTokenExpiresAt == refreshTokenExpiresAt)&&(identical(other.firstLaunchCompleted, firstLaunchCompleted) || other.firstLaunchCompleted == firstLaunchCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,accessToken,accessTokenExpiresAt,refreshToken,refreshTokenExpiresAt,firstLaunchCompleted);

@override
String toString() {
  return 'TokenModel(accessToken: $accessToken, accessTokenExpiresAt: $accessTokenExpiresAt, refreshToken: $refreshToken, refreshTokenExpiresAt: $refreshTokenExpiresAt, firstLaunchCompleted: $firstLaunchCompleted)';
}


}

/// @nodoc
abstract mixin class _$TokenModelCopyWith<$Res> implements $TokenModelCopyWith<$Res> {
  factory _$TokenModelCopyWith(_TokenModel value, $Res Function(_TokenModel) _then) = __$TokenModelCopyWithImpl;
@override @useResult
$Res call({
 String? accessToken, DateTime? accessTokenExpiresAt, String? refreshToken, DateTime? refreshTokenExpiresAt, bool firstLaunchCompleted
});




}
/// @nodoc
class __$TokenModelCopyWithImpl<$Res>
    implements _$TokenModelCopyWith<$Res> {
  __$TokenModelCopyWithImpl(this._self, this._then);

  final _TokenModel _self;
  final $Res Function(_TokenModel) _then;

/// Create a copy of TokenModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = freezed,Object? accessTokenExpiresAt = freezed,Object? refreshToken = freezed,Object? refreshTokenExpiresAt = freezed,Object? firstLaunchCompleted = null,}) {
  return _then(_TokenModel(
accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,accessTokenExpiresAt: freezed == accessTokenExpiresAt ? _self.accessTokenExpiresAt : accessTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,refreshTokenExpiresAt: freezed == refreshTokenExpiresAt ? _self.refreshTokenExpiresAt : refreshTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,firstLaunchCompleted: null == firstLaunchCompleted ? _self.firstLaunchCompleted : firstLaunchCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
