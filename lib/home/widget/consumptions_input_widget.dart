import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:splitly/home/widget/widget.dart';

class ConsumptionsInputWidget extends StatelessWidget {
  const ConsumptionsInputWidget({
    required this.participants,
    required this.expenses,
    required this.consumptions,
    required this.onAddConsumption,
    required this.onRemoveConsumption,
    super.key,
  });

  final List<Participant> participants;
  final List<Expense> expenses;
  final List<Consumption> consumptions;
  final void Function(Consumption) onAddConsumption;
  final void Function(Consumption) onRemoveConsumption;

  @override
  Widget build(BuildContext context) {
    final leftItems = <Widget>[];
    final rightItems = <Widget>[];

    for (final element in consumptions) {
      final i = consumptions.indexOf(element);
      final item = ConsumptionItem(
        consumption: element,
        onRemoveConsumption: onRemoveConsumption,
      );

      i.isEven ? leftItems.add(item) : rightItems.add(item);
    }

    Future<void> onCreateConsumption() async {
      final consumption = await showDialog<Consumption>(
        context: context,
        builder: (context) => NewConsumptionDialog(
          expenses: expenses,
          participants: participants,
          consumptions: consumptions,
        ),
      );

      if (consumption == null) return;

      onAddConsumption(consumption);
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(15.sp),
            Column(children: leftItems),
            const Spacer(),
            Column(children: rightItems),
            Gap(15.sp),
          ],
        ),
        if (leftItems.isNotEmpty || rightItems.isNotEmpty) Gap(2.h),
        Center(
          child: TextButton(
            onPressed: participants.isEmpty || expenses.isEmpty
                ? null
                : onCreateConsumption,
            child: const Text('Agregar consumo'),
          ),
        ),
      ],
    );
  }
}
