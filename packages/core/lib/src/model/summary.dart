import 'package:core/core.dart';

class Summary {
  const Summary({
    this.totalSpent,
    this.persons,
  });

  factory Summary.fromJson(JSON? json) => Summary(
        totalSpent: json?['total_spent'] as double?,
        persons: List<String>.from(json?['persons'] as List? ?? []),
      );

  final double? totalSpent;
  final List<String>? persons;
}
