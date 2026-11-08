import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/result.dart';

part 'session_state.freezed.dart';

@freezed
abstract class SessionState with _$SessionState {
  const factory SessionState({
    @Default(true) bool isRestoringSession,
    @Default(false) bool isAuthenticated,
    @Default(false) bool justRegistered,
    AuthFailure? failure,
    @Default(false) bool isLoading,
  }) = _SessionState;
}
