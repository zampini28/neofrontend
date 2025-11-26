import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:physioapp/services/auth/auth_form.dart';
import 'package:physioapp/utils/get_image.dart';


class ImagePicket extends StatefulWidget {
  const ImagePicket({super.key});

  @override
  ImagePicketState createState() => ImagePicketState();
}

class ImagePicketState extends State<ImagePicket> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: AuthFormData.imageProfile != null ? MemoryImage(base64Decode(AuthFormData.imageProfile!)) : null,
            radius: 50,
          ),
          TextButton.icon(
            onPressed: () async {
              await getImage(context);
              setState((){});
            },
            label: const Text(
              'Selecionar Foto de Perfil',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            icon: const Icon(
              Icons.photo,
              size: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
