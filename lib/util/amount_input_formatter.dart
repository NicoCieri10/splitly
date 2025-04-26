import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AmountInputFormatter extends TextInputFormatter {
  final _formatter = NumberFormat.decimalPattern('es_AR');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;

    // Permitir texto vacío
    if (newText.isEmpty) return newValue;

    // Dividir parte entera y decimal
    final parts = newText.split(',');

    // Limpiar parte entera
    final intPart = parts[0].replaceAll('.', '');

    // Si no es numérico, mantener valor anterior
    if (!RegExp(r'^\d*$').hasMatch(intPart)) return oldValue;

    // Formatear parte entera
    final formattedInt = _formatter.format(int.tryParse(intPart) ?? 0);

    // Reconstruir el texto con la parte decimal (si existe)
    final formatted =
        parts.length > 1 ? '$formattedInt,${parts[1]}' : formattedInt;

    // Calcular nueva posición del cursor
    final newSelectionIndex =
        formatted.length - (newValue.text.length - newValue.selection.end);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: newSelectionIndex.clamp(0, formatted.length),
      ),
    );
  }
}
