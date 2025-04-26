import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({
    required this.expense,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Expense expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'es_AR',
      symbol: r'$',
      decimalDigits: 2,
      customPattern: '\u00A4 #,##0.00',
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 5.w,
        vertical: 1.h,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailWidget(
                category: 'Gasto: ',
                value: expense.name,
              ),
              const Gap(10),
              _DetailWidget(
                category: 'Valor: ',
                value: formatter.format(expense.amount),
              ),
              const Gap(10),
              _DetailWidget(
                category: 'Pagado por: ',
                value: expense.paidBy.name,
              ),
            ],
          ),
          _OptionsWidget(
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        ],
      ),
    );
  }
}

class _OptionsWidget extends StatelessWidget {
  const _OptionsWidget({
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton.filled(
          onPressed: onEdit,
          icon: const Icon(Icons.edit),
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.green),
          ),
          iconSize: 20,
        ),
        IconButton.filled(
          onPressed: onDelete,
          icon: const Icon(Icons.delete),
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
          iconSize: 20,
        ),
      ],
    );
  }
}

class _DetailWidget extends StatelessWidget {
  const _DetailWidget({
    required this.category,
    required this.value,
  });

  final String category;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65.w,
      child: Row(
        children: [
          Text(
            category,
            style: const TextStyle(fontSize: 10),
          ),
          Flexible(child: Text(value)),
        ],
      ),
    );
  }
}
