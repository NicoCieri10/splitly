import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

class ConsumptionItem extends StatelessWidget {
  const ConsumptionItem({
    required this.consumption,
    required this.onRemoveConsumption,
    super.key,
  });

  final Consumption consumption;
  final void Function(Consumption) onRemoveConsumption;

  @override
  Widget build(BuildContext context) {
    final items = consumption.expenses.map(
      (e) => Text(
        '- ${e.name}',
        style: TextStyle(fontSize: 16.sp),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 5.w,
        vertical: 1.h,
      ),
      padding: EdgeInsets.all(15.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                consumption.participant.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
              Gap(25.sp),
              InkWell(
                onTap: () => onRemoveConsumption(consumption),
                child: const Icon(Icons.close_outlined),
              ),
            ],
          ),
          Gap(10.sp),
          ...items,
        ],
      ),
    );
  }
}
