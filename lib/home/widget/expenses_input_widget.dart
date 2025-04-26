import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:splitly/home/widget/widget.dart';

class ExpensesInputWidget extends StatelessWidget {
  const ExpensesInputWidget({
    required this.expenses,
    required this.participants,
    required this.onAddExpense,
    required this.onEditExpense,
    required this.onRemoveExpense,
    super.key,
  });

  final List<Expense> expenses;
  final List<Participant> participants;
  final void Function(Expense) onAddExpense;
  final void Function(Expense, Expense) onEditExpense;
  final void Function(Expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    Future<void> onCreateExpense() async {
      final expense = await showDialog<Expense>(
        context: context,
        builder: (context) => NewExpenseDialog(participants: participants),
      );

      if (expense == null) return;

      onAddExpense(expense);
    }

    Future<void> onEditExpense(Expense expense) async {
      final newExpense = await showDialog<Expense>(
        context: context,
        builder: (context) => NewExpenseDialog(
          participants: participants,
          expense: expense,
        ),
      );

      if (newExpense == null) return;

      this.onEditExpense(
        newExpense,
        expense,
      );
    }

    final items = expenses.map(
      (expense) => ExpenseItem(
        expense: expense,
        onEdit: () => onEditExpense(expense),
        onDelete: () => onRemoveExpense(expense),
      ),
    );

    return Column(
      children: [
        ...items,
        if (items.isNotEmpty) Gap(2.h),
        Center(
          child: TextButton(
            onPressed: participants.isEmpty ? null : onCreateExpense,
            child: const Text('Agregar gasto'),
          ),
        ),
      ],
    );
  }
}
