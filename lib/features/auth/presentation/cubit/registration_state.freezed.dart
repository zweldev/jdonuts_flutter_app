// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegistrationState {

 bool get isRegistration; bool get phoneSubmitted; bool get otpVerified; bool get nameCompleted; RegistrationDraft get draft; bool get isLoading; PhoneError? get phoneError; NameError? get nameError; DobError? get dobError; AuthFailure? get failure;
/// Create a copy of RegistrationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegistrationStateCopyWith<RegistrationState> get copyWith => _$RegistrationStateCopyWithImpl<RegistrationState>(this as RegistrationState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RegistrationState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegistrationState&&(identical(other.isRegistration, _this.isRegistration) || other.isRegistration == _this.isRegistration)&&(identical(other.phoneSubmitted, _this.phoneSubmitted) || other.phoneSubmitted == _this.phoneSubmitted)&&(identical(other.otpVerified, _this.otpVerified) || other.otpVerified == _this.otpVerified)&&(identical(other.nameCompleted, _this.nameCompleted) || other.nameCompleted == _this.nameCompleted)&&(identical(other.draft, _this.draft) || other.draft == _this.draft)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.phoneError, _this.phoneError) || other.phoneError == _this.phoneError)&&(identical(other.nameError, _this.nameError) || other.nameError == _this.nameError)&&(identical(other.dobError, _this.dobError) || other.dobError == _this.dobError)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as RegistrationState;
  return Object.hash(runtimeType,_this.isRegistration,_this.phoneSubmitted,_this.otpVerified,_this.nameCompleted,_this.draft,_this.isLoading,_this.phoneError,_this.nameError,_this.dobError,_this.failure);
}

@override
String toString() {
  final _this = this as RegistrationState;
  return 'RegistrationState(isRegistration: ${_this.isRegistration}, phoneSubmitted: ${_this.phoneSubmitted}, otpVerified: ${_this.otpVerified}, nameCompleted: ${_this.nameCompleted}, draft: ${_this.draft}, isLoading: ${_this.isLoading}, phoneError: ${_this.phoneError}, nameError: ${_this.nameError}, dobError: ${_this.dobError}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $RegistrationStateCopyWith<$Res>  {
  factory $RegistrationStateCopyWith(RegistrationState value, $Res Function(RegistrationState) _then) = _$RegistrationStateCopyWithImpl;
@useResult
$Res call({
 bool isRegistration, bool phoneSubmitted, bool otpVerified, bool nameCompleted, RegistrationDraft draft, bool isLoading, PhoneError? phoneError, NameError? nameError, DobError? dobError, AuthFailure? failure
});




}
/// @nodoc
class _$RegistrationStateCopyWithImpl<$Res>
    implements $RegistrationStateCopyWith<$Res> {
  _$RegistrationStateCopyWithImpl(this._self, this._then);

  final RegistrationState _self;
  final $Res Function(RegistrationState) _then;

/// Create a copy of RegistrationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isRegistration = null,Object? phoneSubmitted = null,Object? otpVerified = null,Object? nameCompleted = null,Object? draft = null,Object? isLoading = null,Object? phoneError = freezed,Object? nameError = freezed,Object? dobError = freezed,Object? failure = freezed,}) {
  return _then(RegistrationState(
isRegistration: null == isRegistration ? _self.isRegistration : isRegistration // ignore: cast_nullable_to_non_nullable
as bool,phoneSubmitted: null == phoneSubmitted ? _self.phoneSubmitted : phoneSubmitted // ignore: cast_nullable_to_non_nullable
as bool,otpVerified: null == otpVerified ? _self.otpVerified : otpVerified // ignore: cast_nullable_to_non_nullable
as bool,nameCompleted: null == nameCompleted ? _self.nameCompleted : nameCompleted // ignore: cast_nullable_to_non_nullable
as bool,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as RegistrationDraft,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,phoneError: freezed == phoneError ? _self.phoneError : phoneError // ignore: cast_nullable_to_non_nullable
as PhoneError?,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as NameError?,dobError: freezed == dobError ? _self.dobError : dobError // ignore: cast_nullable_to_non_nullable
as DobError?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AuthFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [RegistrationState].
extension RegistrationStatePatterns on RegistrationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegistrationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegistrationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegistrationState value)  $default,){
final _that = this;
switch (_that) {
case _RegistrationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegistrationState value)?  $default,){
final _that = this;
switch (_that) {
case _RegistrationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isRegistration,  bool phoneSubmitted,  bool otpVerified,  bool nameCompleted,  RegistrationDraft draft,  bool isLoading,  PhoneError? phoneError,  NameError? nameError,  DobError? dobError,  AuthFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegistrationState() when $default != null:
return $default(_that.isRegistration,_that.phoneSubmitted,_that.otpVerified,_that.nameCompleted,_that.draft,_that.isLoading,_that.phoneError,_that.nameError,_that.dobError,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isRegistration,  bool phoneSubmitted,  bool otpVerified,  bool nameCompleted,  RegistrationDraft draft,  bool isLoading,  PhoneError? phoneError,  NameError? nameError,  DobError? dobError,  AuthFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _RegistrationState():
return $default(_that.isRegistration,_that.phoneSubmitted,_that.otpVerified,_that.nameCompleted,_that.draft,_that.isLoading,_that.phoneError,_that.nameError,_that.dobError,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isRegistration,  bool phoneSubmitted,  bool otpVerified,  bool nameCompleted,  RegistrationDraft draft,  bool isLoading,  PhoneError? phoneError,  NameError? nameError,  DobError? dobError,  AuthFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _RegistrationState() when $default != null:
return $default(_that.isRegistration,_that.phoneSubmitted,_that.otpVerified,_that.nameCompleted,_that.draft,_that.isLoading,_that.phoneError,_that.nameError,_that.dobError,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _RegistrationState implements RegistrationState {
  const _RegistrationState({this.isRegistration = true, this.phoneSubmitted = false, this.otpVerified = false, this.nameCompleted = false, this.draft = const RegistrationDraft(), this.isLoading = false, this.phoneError, this.nameError, this.dobError, this.failure});
  

@override@JsonKey() final  bool isRegistration;
@override@JsonKey() final  bool phoneSubmitted;
@override@JsonKey() final  bool otpVerified;
@override@JsonKey() final  bool nameCompleted;
@override@JsonKey() final  RegistrationDraft draft;
@override@JsonKey() final  bool isLoading;
@override final  PhoneError? phoneError;
@override final  NameError? nameError;
@override final  DobError? dobError;
@override final  AuthFailure? failure;

/// Create a copy of RegistrationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegistrationStateCopyWith<_RegistrationState> get copyWith => __$RegistrationStateCopyWithImpl<_RegistrationState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegistrationState&&(identical(other.isRegistration, isRegistration) || other.isRegistration == isRegistration)&&(identical(other.phoneSubmitted, phoneSubmitted) || other.phoneSubmitted == phoneSubmitted)&&(identical(other.otpVerified, otpVerified) || other.otpVerified == otpVerified)&&(identical(other.nameCompleted, nameCompleted) || other.nameCompleted == nameCompleted)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.phoneError, phoneError) || other.phoneError == phoneError)&&(identical(other.nameError, nameError) || other.nameError == nameError)&&(identical(other.dobError, dobError) || other.dobError == dobError)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isRegistration,phoneSubmitted,otpVerified,nameCompleted,draft,isLoading,phoneError,nameError,dobError,failure);
}

@override
String toString() {
    return 'RegistrationState(isRegistration: $isRegistration, phoneSubmitted: $phoneSubmitted, otpVerified: $otpVerified, nameCompleted: $nameCompleted, draft: $draft, isLoading: $isLoading, phoneError: $phoneError, nameError: $nameError, dobError: $dobError, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$RegistrationStateCopyWith<$Res> implements $RegistrationStateCopyWith<$Res> {
  factory _$RegistrationStateCopyWith(_RegistrationState value, $Res Function(_RegistrationState) _then) = __$RegistrationStateCopyWithImpl;
@override @useResult
$Res call({
 bool isRegistration, bool phoneSubmitted, bool otpVerified, bool nameCompleted, RegistrationDraft draft, bool isLoading, PhoneError? phoneError, NameError? nameError, DobError? dobError, AuthFailure? failure
});




}
/// @nodoc
class __$RegistrationStateCopyWithImpl<$Res>
    implements _$RegistrationStateCopyWith<$Res> {
  __$RegistrationStateCopyWithImpl(this._self, this._then);

  final _RegistrationState _self;
  final $Res Function(_RegistrationState) _then;

/// Create a copy of RegistrationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isRegistration = null,Object? phoneSubmitted = null,Object? otpVerified = null,Object? nameCompleted = null,Object? draft = null,Object? isLoading = null,Object? phoneError = freezed,Object? nameError = freezed,Object? dobError = freezed,Object? failure = freezed,}) {
  return _then(_RegistrationState(
isRegistration: null == isRegistration ? _self.isRegistration : isRegistration // ignore: cast_nullable_to_non_nullable
as bool,phoneSubmitted: null == phoneSubmitted ? _self.phoneSubmitted : phoneSubmitted // ignore: cast_nullable_to_non_nullable
as bool,otpVerified: null == otpVerified ? _self.otpVerified : otpVerified // ignore: cast_nullable_to_non_nullable
as bool,nameCompleted: null == nameCompleted ? _self.nameCompleted : nameCompleted // ignore: cast_nullable_to_non_nullable
as bool,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as RegistrationDraft,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,phoneError: freezed == phoneError ? _self.phoneError : phoneError // ignore: cast_nullable_to_non_nullable
as PhoneError?,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as NameError?,dobError: freezed == dobError ? _self.dobError : dobError // ignore: cast_nullable_to_non_nullable
as DobError?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AuthFailure?,
  ));
}


}

// dart format on
