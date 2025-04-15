// ignore_for_file: lines_longer_than_80_chars

import 'package:core/core.dart';

class PromptData {
  PromptData({
    required this.participants,
    required this.expenses,
    this.consumptions = const [],
    this.conditions = const [],
  });

  final List<String> participants;
  final List<Expense> expenses;
  final List<String> consumptions;
  final List<String> conditions;

  String toPrompt() {
    final buffer = StringBuffer()
      ..writeln(
        'I will provide you with the details of a gathering involving multiple people and their individual consumptions. I need you to automatically calculate how much each person should pay, based on what they consumed and what they already paid. Then, tell me who owes whom and how much.\n',
      )
      ..writeln('**Participants**:\n${participants.join(', ')}\n')
      ..writeln(
        '**Expenses**:\n${expenses.map((e) => e.toString()).join(', ')}\n',
      )
      ..writeln('**Individual consumptions**:');

    consumptions.isEmpty
        ? buffer.writeln('Everyone consumed everything.')
        : consumptions.forEach(buffer.writeln);

    buffer
      ..writeln()
      ..writeln('**Special conditions**:');

    conditions.isEmpty
        ? buffer.writeln('None')
        : conditions.forEach(buffer.writeln);

    buffer
      ..writeln()
      ..writeln('**Instructions**:')
      ..writeln(
        "- Split each item's cost only among the people who consumed it.",
      )
      ..writeln(
        '- If no consumers are specified for an item, assume everyone consumed it.',
      )
      ..writeln(
        '- Calculate how much each person *should* pay, how much they *actually* paid, and if they have credit or debt.',
      )
      ..writeln('- Calculate who owes whom and how much.')
      ..writeln(
        '- Exclude from debt anyone whose expenses were covered by others (e.g., if Nico covers Agus).',
      )
      ..writeln('- Sort the `by_person` list alphabetically by name.')
      ..writeln(
        '- If there are no relevant notes or special comments, return `"notes": []`.\n',
      )
      ..writeln('**IMPORTANT**:')
      ..writeln(
        'Respond **only** with a JSON object in the following structure:\n',
      )
      ..writeln(
        '{\n'
        '  "summary": {\n'
        '    "total_spent": 0.0,\n'
        '    "persons": []\n'
        '  },\n'
        '  "by_person": [\n'
        '    { "name": "", "total": 0.0, "paid": 0.0 }\n'
        '  ],\n'
        '  "debts": [\n'
        '    { "debtor": "", "creditor": "", "amount": 0.0 }\n'
        '  ],\n'
        '  "notes": []\n'
        '}\n',
      );

    return buffer.toString();
  }
}
