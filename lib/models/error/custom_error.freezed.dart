// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomError {

 String get message; String get userMessage;
/// Create a copy of CustomError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomErrorCopyWith<CustomError> get copyWith => _$CustomErrorCopyWithImpl<CustomError>(this as CustomError, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomError&&(identical(other.message, message) || other.message == message)&&(identical(other.userMessage, userMessage) || other.userMessage == userMessage));
}


@override
int get hashCode => Object.hash(runtimeType,message,userMessage);

@override
String toString() {
  return 'CustomError(message: $message, userMessage: $userMessage)';
}


}

/// @nodoc
abstract mixin class $CustomErrorCopyWith<$Res>  {
  factory $CustomErrorCopyWith(CustomError value, $Res Function(CustomError) _then) = _$CustomErrorCopyWithImpl;
@useResult
$Res call({
 String message, String userMessage
});




}
/// @nodoc
class _$CustomErrorCopyWithImpl<$Res>
    implements $CustomErrorCopyWith<$Res> {
  _$CustomErrorCopyWithImpl(this._self, this._then);

  final CustomError _self;
  final $Res Function(CustomError) _then;

/// Create a copy of CustomError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? userMessage = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,userMessage: null == userMessage ? _self.userMessage : userMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class ServerError implements CustomError {
  const ServerError({required this.statusCode, required this.message, required this.userMessage});
  

 final  int statusCode;
@override final  String message;
@override final  String userMessage;

/// Create a copy of CustomError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerErrorCopyWith<ServerError> get copyWith => _$ServerErrorCopyWithImpl<ServerError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerError&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.message, message) || other.message == message)&&(identical(other.userMessage, userMessage) || other.userMessage == userMessage));
}


@override
int get hashCode => Object.hash(runtimeType,statusCode,message,userMessage);

@override
String toString() {
  return 'CustomError.server(statusCode: $statusCode, message: $message, userMessage: $userMessage)';
}


}

/// @nodoc
abstract mixin class $ServerErrorCopyWith<$Res> implements $CustomErrorCopyWith<$Res> {
  factory $ServerErrorCopyWith(ServerError value, $Res Function(ServerError) _then) = _$ServerErrorCopyWithImpl;
@override @useResult
$Res call({
 int statusCode, String message, String userMessage
});




}
/// @nodoc
class _$ServerErrorCopyWithImpl<$Res>
    implements $ServerErrorCopyWith<$Res> {
  _$ServerErrorCopyWithImpl(this._self, this._then);

  final ServerError _self;
  final $Res Function(ServerError) _then;

/// Create a copy of CustomError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statusCode = null,Object? message = null,Object? userMessage = null,}) {
  return _then(ServerError(
statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,userMessage: null == userMessage ? _self.userMessage : userMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TimeoutError implements CustomError {
  const TimeoutError({required this.message, this.userMessage = 'リクエストがタイムアウトしました。時間を置いて再試行してください。'});
  

@override final  String message;
@override@JsonKey() final  String userMessage;

/// Create a copy of CustomError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeoutErrorCopyWith<TimeoutError> get copyWith => _$TimeoutErrorCopyWithImpl<TimeoutError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeoutError&&(identical(other.message, message) || other.message == message)&&(identical(other.userMessage, userMessage) || other.userMessage == userMessage));
}


@override
int get hashCode => Object.hash(runtimeType,message,userMessage);

@override
String toString() {
  return 'CustomError.timeout(message: $message, userMessage: $userMessage)';
}


}

/// @nodoc
abstract mixin class $TimeoutErrorCopyWith<$Res> implements $CustomErrorCopyWith<$Res> {
  factory $TimeoutErrorCopyWith(TimeoutError value, $Res Function(TimeoutError) _then) = _$TimeoutErrorCopyWithImpl;
@override @useResult
$Res call({
 String message, String userMessage
});




}
/// @nodoc
class _$TimeoutErrorCopyWithImpl<$Res>
    implements $TimeoutErrorCopyWith<$Res> {
  _$TimeoutErrorCopyWithImpl(this._self, this._then);

  final TimeoutError _self;
  final $Res Function(TimeoutError) _then;

/// Create a copy of CustomError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? userMessage = null,}) {
  return _then(TimeoutError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,userMessage: null == userMessage ? _self.userMessage : userMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class NetworkError implements CustomError {
  const NetworkError({required this.message, this.userMessage = 'ネットワークに接続できません。接続を確認してください。'});
  

@override final  String message;
@override@JsonKey() final  String userMessage;

/// Create a copy of CustomError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkErrorCopyWith<NetworkError> get copyWith => _$NetworkErrorCopyWithImpl<NetworkError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkError&&(identical(other.message, message) || other.message == message)&&(identical(other.userMessage, userMessage) || other.userMessage == userMessage));
}


@override
int get hashCode => Object.hash(runtimeType,message,userMessage);

@override
String toString() {
  return 'CustomError.network(message: $message, userMessage: $userMessage)';
}


}

/// @nodoc
abstract mixin class $NetworkErrorCopyWith<$Res> implements $CustomErrorCopyWith<$Res> {
  factory $NetworkErrorCopyWith(NetworkError value, $Res Function(NetworkError) _then) = _$NetworkErrorCopyWithImpl;
@override @useResult
$Res call({
 String message, String userMessage
});




}
/// @nodoc
class _$NetworkErrorCopyWithImpl<$Res>
    implements $NetworkErrorCopyWith<$Res> {
  _$NetworkErrorCopyWithImpl(this._self, this._then);

  final NetworkError _self;
  final $Res Function(NetworkError) _then;

/// Create a copy of CustomError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? userMessage = null,}) {
  return _then(NetworkError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,userMessage: null == userMessage ? _self.userMessage : userMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UnknownError implements CustomError {
  const UnknownError({required this.message, this.userMessage = '不明なエラーが発生しました。'});
  

@override final  String message;
@override@JsonKey() final  String userMessage;

/// Create a copy of CustomError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownErrorCopyWith<UnknownError> get copyWith => _$UnknownErrorCopyWithImpl<UnknownError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownError&&(identical(other.message, message) || other.message == message)&&(identical(other.userMessage, userMessage) || other.userMessage == userMessage));
}


@override
int get hashCode => Object.hash(runtimeType,message,userMessage);

@override
String toString() {
  return 'CustomError.unknown(message: $message, userMessage: $userMessage)';
}


}

/// @nodoc
abstract mixin class $UnknownErrorCopyWith<$Res> implements $CustomErrorCopyWith<$Res> {
  factory $UnknownErrorCopyWith(UnknownError value, $Res Function(UnknownError) _then) = _$UnknownErrorCopyWithImpl;
@override @useResult
$Res call({
 String message, String userMessage
});




}
/// @nodoc
class _$UnknownErrorCopyWithImpl<$Res>
    implements $UnknownErrorCopyWith<$Res> {
  _$UnknownErrorCopyWithImpl(this._self, this._then);

  final UnknownError _self;
  final $Res Function(UnknownError) _then;

/// Create a copy of CustomError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? userMessage = null,}) {
  return _then(UnknownError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,userMessage: null == userMessage ? _self.userMessage : userMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
