import 'package:bloc/bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/result.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._repository) : super(const SessionState());

  final AuthRepository _repository;

  Future<void> restoreSession() async {
    final result = await _repository.restoreSession();
    if (isClosed) return;
    switch (result) {
      case Success<bool>(:final value):
        emit(
          state.copyWith(
            isRestoringSession: false,
            isAuthenticated: value,
            failure: null,
          ),
        );
      case Failure<bool>(:final error):
        emit(state.copyWith(isRestoringSession: false, failure: error));
    }
  }

  void markRegistered() => emit(
    state.copyWith(isAuthenticated: true, justRegistered: true, failure: null),
  );

  void markLoggedIn() => emit(
    state.copyWith(isAuthenticated: true, justRegistered: false, failure: null),
  );

  void completeWelcome() => emit(state.copyWith(justRegistered: false));

  Future<void> signOut() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, failure: null));
    final result = await _repository.signOut();
    if (isClosed) return;
    switch (result) {
      case Success<void>():
        emit(const SessionState(isRestoringSession: false));
      case Failure<void>(:final error):
        emit(state.copyWith(isLoading: false, failure: error));
    }
  }
}
