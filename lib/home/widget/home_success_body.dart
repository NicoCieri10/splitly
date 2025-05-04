import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:splitly/home/widget/widget.dart';
import 'package:splitly/widget/custom_button.dart';

class HomeSuccessBody extends StatelessWidget {
  const HomeSuccessBody({
    required this.response,
    required this.onNewRequest,
    required this.promptData,
    super.key,
  });

  final GenerativeResponse? response;
  final VoidCallback onNewRequest;
  final PromptData promptData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subtotal',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total: '),
              Text(
                response?.summary?.totalSpent.toString() ?? 'N/D',
              ),
            ],
          ),
          const Text('Por persona: '),
          PersonalConsumptionWidget(
            consumption: promptData.consumptions[0],
            personalSpent: response?.byPerson?[0],
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
