import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class PersonalConsumptionWidget extends StatelessWidget {
  const PersonalConsumptionWidget({
    required this.consumption,
    required this.personalSpent,
    super.key,
  });

  final Consumption? consumption;
  final PersonalSpent? personalSpent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.sp,
        vertical: 20.sp,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            consumption?.participant.name ?? 'N/D',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
            ),
          ),
          Gap(10.sp),
          _ConsumptionTextWidget(consumption?.expenses[0].name),
          _ConsumptionTextWidget(consumption?.expenses[1].name),
          Gap(10.sp),
          _RowItem(
            text: 'Consumo total: ',
            amount: personalSpent?.total ?? 0,
          ),
          _RowItem(
            text: 'Pagado: ',
            amount: personalSpent?.paid ?? 0,
          ),
          Gap(15.sp),
          const Row(
            children: [
              Text('Debe: '),
              Text('N/D'),
            ],
          ),
        ],
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({
    required this.text,
    required this.amount,
  });

  final String text;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'es_AR',
      symbol: r'$',
      decimalDigits: 2,
      customPattern: '\u00A4 #,##0.00',
    );

    final formattedAmount = formatter.format(amount);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text),
        Text(formattedAmount),
      ],
    );
  }
}

class _ConsumptionTextWidget extends StatelessWidget {
  const _ConsumptionTextWidget(this.consumption);

  final String? consumption;

  @override
  Widget build(BuildContext context) {
    return Text(
      '- ${consumption ?? 'N/D'}',
    );
  }
}
