// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
  id: json['id'] as String?,
  phoneNumber: json['phoneNumber'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
);

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
  'id': instance.id,
  'phoneNumber': instance.phoneNumber,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'dateOfBirth': instance.dateOfBirth.toIso8601String(),
};
