// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OtpState {

 String get code; int get attempts; bool get isLocked; int get secondsUntilResend; bool get isLoading; AuthFailure? get failure;
/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpStateCopyWith<OtpState> get copyWith => _$OtpStateCopyWithImpl<OtpState>(this as OtpState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OtpState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpState&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.attempts, _this.attempts) || other.attempts == _this.attempts)&&(identical(other.isLocked, _this.isLocked) || other.isLocked == _this.isLocked)&&(identical(other.secondsUntilResend, _this.secondsUntilResend) || other.secondsUntilResend == _this.secondsUntilResend)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as OtpState;
  return Object.hash(runtimeType,_this.code,_this.attempts,_this.isLocked,_this.secondsUntilResend,_this.isLoading,_this.failure);
}

@override
String toString() {
  final _this = this as OtpState;
  return 'OtpState(code: ${_this.code}, attempts: ${_this.attempts}, isLocked: ${_this.isLocked}, secondsUntilResend: ${_this.secondsUntilResend}, isLoading: ${_this.isLoading}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $OtpStateCopyWith<$Res>  {
  factory $OtpStateCopyWith(OtpState value, $Res Function(OtpState) _then) = _$OtpStateCopyWithImpl;
@useResult
$Res call({
 String code, int attempts, bool isLocked, int secondsUntilResend, bool isLoading, AuthFailure? failure
});




}
/// @nodoc
class _$OtpStateCopyWithImpl<$Res>
    implements $OtpStateCopyWith<$Res> {
  _$OtpStateCopyWithImpl(this._self, this._then);

  final OtpState _self;
  final $Res Function(OtpState) _then;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? attempts = null,Object? isLocked = null,Object? secondsUntilResend = null,Object? isLoading = null,Object? failure = freezed,}) {
  return _then(OtpState(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,secondsUntilResend: null == secondsUntilResend ? _self.secondsUntilResend : secondsUntilResend // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AuthFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [OtpState].
extension OtpStatePatterns on OtpState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OtpState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtpState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OtpState value)  $default,){
final _that = this;
switch (_that) {
case _OtpState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OtpState value)?  $default,){
final _that = this;
switch (_that) {
case _OtpState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  int attempts,  bool isLocked,  int secondsUntilResend,  bool isLoading,  AuthFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OtpState() when $default != null:
return $default(_that.code,_that.attempts,_that.isLocked,_that.secondsUntilResend,_that.isLoading,_that.failure);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  int attempts,  bool isLocked,  int secondsUntilResend,  bool isLoading,  AuthFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _OtpState():
return $default(_that.code,_that.attempts,_that.isLocked,_that.secondsUntilResend,_that.isLoading,_that.failure);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  int attempts,  bool isLocked,  int secondsUntilResend,  bool isLoading,  AuthFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _OtpState() when $default != null:
return $default(_that.code,_that.attempts,_that.isLocked,_that.secondsUntilResend,_that.isLoading,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _OtpState implements OtpState {
  const _OtpState({this.code = '', this.attempts = 0, this.isLocked = false, this.secondsUntilResend = otpResendSeconds, this.isLoading = false, this.failure});
  

@override@JsonKey() final  String code;
@override@JsonKey() final  int attempts;
@override@JsonKey() final  bool isLocked;
@override@JsonKey() final  int secondsUntilResend;
@override@JsonKey() final  bool isLoading;
@override final  AuthFailure? failure;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpStateCopyWith<_OtpState> get copyWith => __$OtpStateCopyWithImpl<_OtpState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpState&&(identical(other.code, code) || other.code == code)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.secondsUntilResend, secondsUntilResend) || other.secondsUntilResend == secondsUntilResend)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,attempts,isLocked,secondsUntilResend,isLoading,failure);
}

@override
String toString() {
    return 'OtpState(code: $code, attempts: $attempts, isLocked: $isLocked, secondsUntilResend: $secondsUntilResend, isLoading: $isLoading, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$OtpStateCopyWith<$Res> implements $OtpStateCopyWith<$Res> {
  factory _$OtpStateCopyWith(_OtpState value, $Res Function(_OtpState) _then) = __$OtpStateCopyWithImpl;
@override @useResult
$Res call({
 String code, int attempts, bool isLocked, int secondsUntilResend, bool isLoading, AuthFailure? failure
});




}
/// @nodoc
class __$OtpStateCopyWithImpl<$Res>
    implements _$OtpStateCopyWith<$Res> {
  __$OtpStateCopyWithImpl(this._self, this._then);

  final _OtpState _self;
  final $Res Function(_OtpState) _then;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? attempts = null,Object? isLocked = null,Object? secondsUntilResend = null,Object? isLoading = null,Object? failure = freezed,}) {
  return _then(_OtpState(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,secondsUntilResend: null == secondsUntilResend ? _self.secondsUntilResend : secondsUntilResend // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AuthFailure?,
  ));
}


}

// dart format on
