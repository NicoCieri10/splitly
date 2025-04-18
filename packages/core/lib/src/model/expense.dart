import 'package:core/core.dart';

class Expense {
  const Expense({
    required this.name,
    required this.amount,
    required this.paidBy,
  });

  final String name;
  final double amount;
  final Participant paidBy;

  @override
  String toString() => '$name: $amount-${paidBy.name}';
}
