import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/services/auth/auth_form.dart';

Future<void> getImage(BuildContext context) async {
  try {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 80,
    );

    if (image == null) return;

    final bytes = await image.readAsBytes();

    UserDataCache().saveProfileImage(bytes);

    AuthFormData.imageProfile = base64Encode(bytes);
  } catch (e) {
    debugPrint(' --- FAILED TO GET IMAGE: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erro ao carregar imagem.')),
    );
  }
}

Future<void> updateImage(BuildContext context) async {
  try {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 80,
    );

    if (image == null) return;

    final bytes = await image.readAsBytes();

    UserDataCache().saveProfileImage(bytes);
    updateProfileImage(bytes);
  } catch (e) { 
    debugPrint(' -- failed to get update profile image: $e');
  }

}
