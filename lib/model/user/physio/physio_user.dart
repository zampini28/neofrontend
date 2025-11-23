import 'dart:io';

import 'package:physioapp/services/auth/auth_form.dart';

class PhysioUser {
  final String id;
  final String crefito;
  final RadioButton physioType;
  File imageProfile;
  final String name;
  final String email;

  PhysioUser({
    required this.id,
    required this.crefito,
    required this.physioType,
    required this.imageProfile,
    required this.name,
    required this.email,
  });

  String get firstName {
    final first = name.split(' ')[0];
    final nameFormted =
        first.substring(0, 1).toUpperCase() + first.substring(1);
    return nameFormted;
  }

  String get emailSemiAnonimized {
    final partsEmail = email.split('@');
    final firstPart = partsEmail[0].substring(0, 3);
    final domainAnoni = '$firstPart****@';
    return domainAnoni + partsEmail[1];
  }

  String get userName {
    // 1. Verifica se a string está vazia ou contém apenas espaços.
    if (name.trim().isEmpty) {
      return ''; // Retorna vazio se não houver nome.
    }

    final nameSplitted =
        name.trim().split(RegExp(r'\s+')); // Divide por um ou mais espaços

    // Filtra para remover quaisquer strings vazias que possam ter resultado do split (ex: "Nome  Sobrenome")
    final nonEmpyParts = nameSplitted.where((part) => part.isNotEmpty).toList();

    // 2. Se não houver partes (após a limpeza), retorna vazio.
    if (nonEmpyParts.isEmpty) {
      return '';
    }

    // Função auxiliar para capitalizar a primeira letra de uma parte
    String capitalize(String s) {
      if (s.isEmpty) return '';
      // Garante que o índice 1 existe antes de chamar substring(1)
      return s[0].toUpperCase() + s.substring(1).toLowerCase();
    }

    final firstPart = capitalize(nonEmpyParts.first);

    // 3. Verifica se existe uma segunda parte (sobrenome)
    if (nonEmpyParts.length > 1) {
      final lastPart = capitalize(nonEmpyParts.last);
      return '$firstPart $lastPart';
    } else {
      // Retorna apenas o primeiro nome se não houver um sobrenome
      return firstPart;
    }
  }

  // String get userName {
  //   final nameSplitted = name.split(' ');

  //   final firstPart = nameSplitted.first.substring(0, 1).toUpperCase() +
  //       nameSplitted.first.substring(1);

  //   final lastPart = nameSplitted.last.substring(0, 1).toUpperCase() +
  //       nameSplitted.last.substring(1);
  //   return '$firstPart $lastPart';
  // }

}
