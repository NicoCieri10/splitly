import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget(
    this.text, {
    this.padding,
    super.key,
  });

  final String text;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 5.w),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 18,
              color: const Color.fromARGB(255, 71, 92, 103),
            ),
      ),
    );
  }
}
