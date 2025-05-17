import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
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
    final formatter = NumberFormat.currency(
      locale: 'es_AR',
      symbol: r'$',
      decimalDigits: 2,
      customPattern: '\u00A4 #,##0.00',
    );

    final formattedAmount = formatter.format(response?.summary?.totalSpent);
    return Container(
      alignment: Alignment.center,
      height: 95.h,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      formattedAmount,
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Gap(2.h),
                  Text(
                    'Consumos',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 35.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: response?.byPerson?.length,
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                itemBuilder: (context, index) {
                  final personalSpent = response?.byPerson?[index];
                  final consumption = promptData.consumptions.firstWhereOrNull(
                    (e) => e.participant.name == personalSpent?.name,
                  );

                  return PersonConsumptionWidget(
                    consumption: consumption,
                    personalSpent: personalSpent,
                  );
                },
              ),
            ),
            Gap(5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Text(
                'Resumen',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: response?.debts?.length,
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                itemBuilder: (context, index) => PersonDebtWidget(
                  debt: response?.debts?[index],
                ),
              ),
            ),
            Gap(2.5.h),
            CustomButton(
              text: 'Nueva consulta',
              onPressed: onNewRequest,
            ),
            Gap(2.5.h),
          ],
        ),
      ),
    );
  }
}
