import 'package:flutter/services.dart';

class GalacticTimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text;
    String filteredText = newText.replaceAll(RegExp(r'[^0-9]'), ''); // Allow only digits

    if (filteredText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // YY.M.DD H.MM.SS
    // Lengths of segments: 2, 1, 2, 1, 2, 2
    // Separators: ., .,  , ., .

    StringBuffer formattedText = StringBuffer();
    int digitIndex = 0;

    void appendDigits(int count) {
      if (digitIndex + count <= filteredText.length) {
        formattedText.write(filteredText.substring(digitIndex, digitIndex + count));
        digitIndex += count;
      } else if (digitIndex < filteredText.length) {
        formattedText.write(filteredText.substring(digitIndex));
        digitIndex = filteredText.length;
      }
    }

    // YY
    appendDigits(2);
    if (digitIndex < filteredText.length || newText.length > formattedText.length && formattedText.length == 2) {
      formattedText.write('.');
    }

    // M
    appendDigits(1);
    if (digitIndex < filteredText.length || newText.length > formattedText.length && formattedText.length == 4) {
      formattedText.write('.');
    }

    // DD
    appendDigits(2);
    if (digitIndex < filteredText.length || newText.length > formattedText.length && formattedText.length == 7) {
      formattedText.write(' '); // Space separator
    }

    // H (Assuming single digit for hour for simplicity in this formatter, adjust if needed)
    // If you need HH (two digits for hour), change appendDigits(1) to appendDigits(2)
    appendDigits(1);
    if (digitIndex < filteredText.length || newText.length > formattedText.length && formattedText.length == 9) {
      formattedText.write('.');
    }

    // MM
    appendDigits(2);
    if (digitIndex < filteredText.length || newText.length > formattedText.length && formattedText.length == 12) {
      formattedText.write('.');
    }

    // SS
    appendDigits(2);


    String resultText = formattedText.toString();
    // Limit total length to match YY.M.DD H.MM.SS (15 characters)
    if (resultText.length > 15) {
      resultText = resultText.substring(0, 15);
    }


    return TextEditingValue(
      text: resultText,
      selection: TextSelection.collapsed(offset: resultText.length),
    );
  }
}
