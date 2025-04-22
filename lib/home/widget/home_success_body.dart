import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:splitly/widget/custom_button.dart';

class HomeSuccessBody extends StatelessWidget {
  const HomeSuccessBody({
    required this.response,
    required this.onNewRequest,
    super.key,
  });

  final GenerativeResponse? response;
  final VoidCallback onNewRequest;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            response?.summary?.totalSpent.toString() ?? 'N/D',
          ),
          Text(
            response?.summary?.persons.toString() ?? 'N/D',
          ),
          Text(
            response?.byPerson.toString() ?? 'N/D',
          ),
          const Spacer(),
          CustomButton(
            text: 'Nueva consulta',
            onPressed: onNewRequest,
          ),
          Gap(2.5.h),
        ],
      ),
    );
  }
}
