import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splitly/util/util.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    required this.controller,
    this.label,
    this.hint,
    this.onFieldSubmitted,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.inputFormatters,
    this.prefixText,
    super.key,
  });

  factory CustomInput.amount({
    required TextEditingController controller,
    void Function(String)? onFieldSubmitted,
    String? label,
    String? hint,
  }) =>
      CustomInput(
        controller: controller,
        hint: hint,
        label: label,
        inputFormatters: [
          AmountInputFormatter(),
        ],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        prefixText: r'$ ',
        onFieldSubmitted: onFieldSubmitted,
      );

  final String? label;
  final String? hint;
  final TextEditingController controller;
  final void Function(String)? onFieldSubmitted;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 78, 97, 108),
      ),
      labelText: label,
      labelStyle: const TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 78, 97, 108),
      ),
      isDense: true,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red.shade600,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      prefixText: prefixText,
    );

    return TextFormField(
      controller: controller,
      decoration: decoration,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      onFieldSubmitted: onFieldSubmitted,
      textCapitalization: TextCapitalization.sentences,
    );
  }
}
