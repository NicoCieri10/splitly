import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    required this.controller,
    this.label,
    this.hint,
    this.onFieldSubmitted,
    this.keyboardType,
    super.key,
  });

  final String? label;
  final String? hint;
  final TextEditingController controller;
  final void Function(String)? onFieldSubmitted;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
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
        contentPadding: const EdgeInsets.all(10),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      keyboardType: keyboardType,
      onFieldSubmitted: onFieldSubmitted,
      textCapitalization: TextCapitalization.sentences,
    );
  }
}
