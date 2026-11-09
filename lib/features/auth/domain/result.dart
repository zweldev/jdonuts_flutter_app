sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);

  final AuthFailure error;
}

sealed class AuthFailure {
  const AuthFailure();
}

final class UserNotFound extends AuthFailure {
  const UserNotFound();
}

final class AlreadyRegistered extends AuthFailure {
  const AlreadyRegistered();
}

final class InvalidOtp extends AuthFailure {
  const InvalidOtp();
}

final class NetworkFailure extends AuthFailure {
  const NetworkFailure(this.cause);

  final Object cause;
}

final class StorageFailure extends AuthFailure {
  const StorageFailure(this.cause);

  final Object cause;
}

final class UnknownFailure extends AuthFailure {
  const UnknownFailure(this.cause);

  final Object cause;
}
