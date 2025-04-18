import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SubtitleWidget extends StatelessWidget {
  const SubtitleWidget(
    this.text, {
    this.padding,
    super.key,
  });

  final String text;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 7.5.w),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color.fromARGB(255, 78, 97, 108),
            ),
      ),
    );
  }
}
