import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

enum UserType {
  PHYSIO,
  PATIENT;

  static UserType fromString(String value) {
    return value.toUpperCase() == 'PHYSIO' ? UserType.PHYSIO : UserType.PATIENT;
  }
}

class ConnectedUser {
  final String id;
  final String fullname;
  final String email;
  final String? profileImageBase64;
  final UserType type;

  ConnectedUser({
    required this.id,
    required this.fullname,
    required this.email,
    this.profileImageBase64,
    required this.type,
  });

  factory ConnectedUser.fromJson(Map<String, dynamic> json) {
    return ConnectedUser(
      id: json['id'] as String,
      fullname: json['fullname'] as String ?? 'Usuário',
      email: json['email'] as String ?? '',
      profileImageBase64: json['profileImage'] as String?,
      type: UserType.fromString(json['type'] as String ?? 'PATIENT'),
    );
  }

  ImageProvider get imageProvider {
    if (profileImageBase64 != null && profileImageBase64!.isNotEmpty) {
      try {
        final bytes = base64Decode(profileImageBase64!);
        return MemoryImage(bytes);
      } catch (e) {
        debugPrint('Error decoding base64 image: $e');
      }
    }
    return const AssetImage('assets/fake_profile.jpg');
  }
  
  String get initials {
    final names = fullname.trim().split(' ');
    if (names.isEmpty) return '';
    if (names.length == 1) return names[0][0].toUpperCase();
    return '${names[0][0]}${names.last[0]}'.toUpperCase();
  }
}
