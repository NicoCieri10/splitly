import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:splitly/home/widget/widget.dart';

class ExpensesInputWidget extends StatefulWidget {
  const ExpensesInputWidget({
    required this.expenses,
    required this.participants,
    required this.onAddExpense,
    required this.onRemoveExpense,
    super.key,
  });

  final List<Expense> expenses;
  final List<Participant> participants;
  final void Function(Expense) onAddExpense;
  final void Function(Expense) onRemoveExpense;

  @override
  State<ExpensesInputWidget> createState() => _ExpensesInputWidgetState();
}

class _ExpensesInputWidgetState extends State<ExpensesInputWidget> {
  @override
  Widget build(BuildContext context) {
    final items = widget.expenses.map(
      (expense) => ExpenseItem(
        expense: expense,
        onEdit: () {},
        onDelete: () => widget.onRemoveExpense(expense),
      ),
    );

    Future<void> onCreateExpense() async {
      final expense = await showDialog<Expense>(
        context: context,
        builder: (context) => NewExpenseDialog(
          participants: widget.participants,
        ),
      );

      if (expense == null) return;

      widget.onAddExpense(expense);
    }

    return Column(
      children: [
        ...items,
        if (items.isNotEmpty) Gap(2.h),
        Center(
          child: TextButton(
            onPressed: onCreateExpense,
            child: const Text('Agregar gasto'),
          ),
        ),
      ],
    );
  }
}
