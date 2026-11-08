// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionState {

 bool get isRestoringSession; bool get isAuthenticated; bool get justRegistered; AuthFailure? get failure; bool get isLoading;
/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionStateCopyWith<SessionState> get copyWith => _$SessionStateCopyWithImpl<SessionState>(this as SessionState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SessionState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionState&&(identical(other.isRestoringSession, _this.isRestoringSession) || other.isRestoringSession == _this.isRestoringSession)&&(identical(other.isAuthenticated, _this.isAuthenticated) || other.isAuthenticated == _this.isAuthenticated)&&(identical(other.justRegistered, _this.justRegistered) || other.justRegistered == _this.justRegistered)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading));
}


@override
int get hashCode {
  final _this = this as SessionState;
  return Object.hash(runtimeType,_this.isRestoringSession,_this.isAuthenticated,_this.justRegistered,_this.failure,_this.isLoading);
}

@override
String toString() {
  final _this = this as SessionState;
  return 'SessionState(isRestoringSession: ${_this.isRestoringSession}, isAuthenticated: ${_this.isAuthenticated}, justRegistered: ${_this.justRegistered}, failure: ${_this.failure}, isLoading: ${_this.isLoading})';
}


}

/// @nodoc
abstract mixin class $SessionStateCopyWith<$Res>  {
  factory $SessionStateCopyWith(SessionState value, $Res Function(SessionState) _then) = _$SessionStateCopyWithImpl;
@useResult
$Res call({
 bool isRestoringSession, bool isAuthenticated, bool justRegistered, AuthFailure? failure, bool isLoading
});




}
/// @nodoc
class _$SessionStateCopyWithImpl<$Res>
    implements $SessionStateCopyWith<$Res> {
  _$SessionStateCopyWithImpl(this._self, this._then);

  final SessionState _self;
  final $Res Function(SessionState) _then;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isRestoringSession = null,Object? isAuthenticated = null,Object? justRegistered = null,Object? failure = freezed,Object? isLoading = null,}) {
  return _then(SessionState(
isRestoringSession: null == isRestoringSession ? _self.isRestoringSession : isRestoringSession // ignore: cast_nullable_to_non_nullable
as bool,isAuthenticated: null == isAuthenticated ? _self.isAuthenticated : isAuthenticated // ignore: cast_nullable_to_non_nullable
as bool,justRegistered: null == justRegistered ? _self.justRegistered : justRegistered // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AuthFailure?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionState].
extension SessionStatePatterns on SessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionState value)  $default,){
final _that = this;
switch (_that) {
case _SessionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionState value)?  $default,){
final _that = this;
switch (_that) {
case _SessionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isRestoringSession,  bool isAuthenticated,  bool justRegistered,  AuthFailure? failure,  bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionState() when $default != null:
return $default(_that.isRestoringSession,_that.isAuthenticated,_that.justRegistered,_that.failure,_that.isLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isRestoringSession,  bool isAuthenticated,  bool justRegistered,  AuthFailure? failure,  bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _SessionState():
return $default(_that.isRestoringSession,_that.isAuthenticated,_that.justRegistered,_that.failure,_that.isLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isRestoringSession,  bool isAuthenticated,  bool justRegistered,  AuthFailure? failure,  bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _SessionState() when $default != null:
return $default(_that.isRestoringSession,_that.isAuthenticated,_that.justRegistered,_that.failure,_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _SessionState implements SessionState {
  const _SessionState({this.isRestoringSession = true, this.isAuthenticated = false, this.justRegistered = false, this.failure, this.isLoading = false});
  

@override@JsonKey() final  bool isRestoringSession;
@override@JsonKey() final  bool isAuthenticated;
@override@JsonKey() final  bool justRegistered;
@override final  AuthFailure? failure;
@override@JsonKey() final  bool isLoading;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionStateCopyWith<_SessionState> get copyWith => __$SessionStateCopyWithImpl<_SessionState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionState&&(identical(other.isRestoringSession, isRestoringSession) || other.isRestoringSession == isRestoringSession)&&(identical(other.isAuthenticated, isAuthenticated) || other.isAuthenticated == isAuthenticated)&&(identical(other.justRegistered, justRegistered) || other.justRegistered == justRegistered)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isRestoringSession,isAuthenticated,justRegistered,failure,isLoading);
}

@override
String toString() {
    return 'SessionState(isRestoringSession: $isRestoringSession, isAuthenticated: $isAuthenticated, justRegistered: $justRegistered, failure: $failure, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$SessionStateCopyWith<$Res> implements $SessionStateCopyWith<$Res> {
  factory _$SessionStateCopyWith(_SessionState value, $Res Function(_SessionState) _then) = __$SessionStateCopyWithImpl;
@override @useResult
$Res call({
 bool isRestoringSession, bool isAuthenticated, bool justRegistered, AuthFailure? failure, bool isLoading
});




}
/// @nodoc
class __$SessionStateCopyWithImpl<$Res>
    implements _$SessionStateCopyWith<$Res> {
  __$SessionStateCopyWithImpl(this._self, this._then);

  final _SessionState _self;
  final $Res Function(_SessionState) _then;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isRestoringSession = null,Object? isAuthenticated = null,Object? justRegistered = null,Object? failure = freezed,Object? isLoading = null,}) {
  return _then(_SessionState(
isRestoringSession: null == isRestoringSession ? _self.isRestoringSession : isRestoringSession // ignore: cast_nullable_to_non_nullable
as bool,isAuthenticated: null == isAuthenticated ? _self.isAuthenticated : isAuthenticated // ignore: cast_nullable_to_non_nullable
as bool,justRegistered: null == justRegistered ? _self.justRegistered : justRegistered // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AuthFailure?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
