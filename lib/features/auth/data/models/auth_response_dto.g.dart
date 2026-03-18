// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponseDto _$AuthResponseDtoFromJson(Map<String, dynamic> json) =>
    AuthResponseDto(
      success: json['success'] as bool,
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      message: json['message'] as String?,
      refreshToken: json['refreshToken'] as String?,
      expiresIn: (json['expiresIn'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AuthResponseDtoToJson(AuthResponseDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'user': instance.user,
      'token': instance.token,
      'message': instance.message,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
    };

TokenRefreshResponseDto _$TokenRefreshResponseDtoFromJson(
        Map<String, dynamic> json) =>
    TokenRefreshResponseDto(
      success: json['success'] as bool,
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String?,
      expiresIn: (json['expiresIn'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TokenRefreshResponseDtoToJson(
        TokenRefreshResponseDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
    };
