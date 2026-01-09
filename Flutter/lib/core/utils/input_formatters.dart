import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String formatted = '';

    // Format: (555) 123-4567
    if (text.length <= 3) {
      formatted = text;
    } else if (text.length <= 6) {
      formatted = '(${text.substring(0, 3)}) ${text.substring(3)}';
    } else if (text.length <= 10) {
      formatted =
          '(${text.substring(0, 3)}) ${text.substring(3, 6)}-${text.substring(6)}';
    } else {
      formatted =
          '(${text.substring(0, 3)}) ${text.substring(3, 6)}-${text.substring(6, 10)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
