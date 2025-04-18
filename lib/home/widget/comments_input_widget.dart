import 'package:flutter/material.dart';
import 'package:splitly/widget/widget.dart';

class CommentsInputWidget extends StatelessWidget {
  const CommentsInputWidget({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: CustomInput(
        controller: controller,
        hint: 'Comentarios',
        minLines: 3,
        maxLines: 10,
      ),
    );
  }
}
