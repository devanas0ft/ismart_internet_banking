import 'package:flutter/services.dart';

class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue prevText, TextEditingValue currText) {
    String formattedText = '';
    int selectionIndex = currText.selection.end;

    // Remove any non-digit characters from the current text
    String digitsOnly = currText.text.replaceAll(RegExp(r'[^\d]'), '');

    // Format the digits into YYYY/MM/DD
    if (digitsOnly.isNotEmpty) {
      formattedText += digitsOnly.substring(0, 4); // Year
      if (digitsOnly.length >= 5) {
        formattedText += '-' + digitsOnly.substring(4, 6); // Month
        if (digitsOnly.length >= 7) {
          formattedText += '-' + digitsOnly.substring(6, 8); // Day
        }
      }
    }

    // Adjust the selection index based on the formatted text
    if (currText.selection.end >= currText.selection.start) {
      selectionIndex += formattedText.length - currText.text.length;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
