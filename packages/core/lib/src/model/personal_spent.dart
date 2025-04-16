import 'package:core/core.dart';

class PersonalSpent {
  PersonalSpent({
    this.name,
    this.total,
    this.paid,
  });

  factory PersonalSpent.fromJson(JSON? json) => PersonalSpent(
        name: json?['name'] as String?,
        total: json?['total'] as double?,
        paid: json?['paid'] as double?,
      );

  final String? name;
  final double? total;
  final double? paid;

  @override
  String toString() {
    return '\n name: $name, total: $total, paid: $paid';
  }
}
