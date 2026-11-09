import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    String? id,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}
