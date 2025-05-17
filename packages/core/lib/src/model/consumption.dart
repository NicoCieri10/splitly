import 'package:core/core.dart';

class Consumption {
  const Consumption({
    required this.participant,
    required this.expenses,
  });

  final Participant participant;
  final List<Expense> expenses;

  @override
  String toString() {
    final consumedItemNames = expenses.map((e) => e.name).join(', ');
    return '$participant consumed: $consumedItemNames';
  }
}
