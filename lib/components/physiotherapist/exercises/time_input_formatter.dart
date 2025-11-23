import 'package:flutter/services.dart';

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text.replaceAll(':', '');
    final String oldText = oldValue.text.replaceAll(':', '');

    if (newText.length > 4) {
      return oldValue; // Limita a 4 dígitos
    }

    // Se o usuário apagar o caractere, o cursor deve permanecer no lugar certo
    if (oldText.length > newText.length) {
      return newValue;
    }

    String formattedText = '';
    if (newText.length > 2) {
      formattedText = '${newText.substring(0, 2)}:${newText.substring(2)}';
    } else {
      formattedText = newText;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
