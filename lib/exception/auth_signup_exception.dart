import 'package:flutter/material.dart';

class AuthSignupException {
  void showErrorSubmit(
      {required String messageError, required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text('Falha no envio do formulário'),
          content: Text(messageError),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void showErrorValidate(
      {required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  bool validateName({required String? name, required BuildContext context}) {
    if (name == null || name.isEmpty || name.length < 5) {
      return true;
    } else {
      return false;
    }
  }

  bool validateEmail({required String? email, required BuildContext context}) {
    if (email == null || email.isEmpty || !email.contains('@')) {
      return true;
    } else {
      return false;
    }
  }

  bool validatePassword({
    required String? password,
    required BuildContext context,
  }) {
    if (password == null || password.isEmpty || password.length < 6) {
      return true;
    } else {
      return false;
    }
  }

  bool confirmPasswordValid({
    required String? confirmPassword,
    required String? password,
    required BuildContext context,
  }) {
    if (confirmPassword != password) {
      return true;
    } else {
      return false;
    }
  }
}
