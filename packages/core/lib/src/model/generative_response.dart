import 'dart:convert';

import 'package:core/core.dart';

class GenerativeResponse {
  GenerativeResponse({
    this.summary,
    this.byPerson,
    this.debts,
    this.notes,
  });

  factory GenerativeResponse.fromJson(String json) {
    final map = jsonDecode(_cleanResponse(json)) as JSON;
    return GenerativeResponse.fromMap(map);
  }

  factory GenerativeResponse.fromMap(JSON map) {
    final byPerson = map['by_person'] as JSONList?;
    final debts = map['debts'] as JSONList?;
    return GenerativeResponse(
      summary: Summary.fromJson(map['summary'] as JSON?),
      byPerson: byPerson != null && byPerson.isNotEmpty
          ? byPerson.map(PersonalSpent.fromJson).toList()
          : [],
      debts: debts != null && debts.isNotEmpty
          ? debts.map(Debt.fromJson).toList()
          : [],
      notes: List<String>.from(map['notes'] as List? ?? []),
    );
  }

  final Summary? summary;
  final List<PersonalSpent>? byPerson;
  final List<Debt>? debts;
  final List<String>? notes;

  // Elimina los backticks y etiquetas tipo ```json
  static String _cleanResponse(String raw) => raw
      .replaceAll(RegExp(r'^```json\s*'), '')
      .replaceAll(RegExp(r'```$'), '')
      .trim();
}
