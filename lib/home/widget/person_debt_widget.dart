import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class PersonDebtWidget extends StatelessWidget {
  const PersonDebtWidget({
    required this.debt,
    super.key,
  });

  final Debt? debt;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'es_AR',
      symbol: r'$',
      decimalDigits: 2,
      customPattern: '\u00A4 #,##0.00',
    );

    final formattedAmount = formatter.format(debt?.amount);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10.sp),
      ),
      padding: EdgeInsets.all(20.sp),
      margin: EdgeInsets.all(2.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10.sp,
        children: [
          Text(
            debt?.debtor ?? 'N/D',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20.sp,
            ),
          ),
          Text(
            'Le debe $formattedAmount',
            style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'A ${debt?.creditor}',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}
