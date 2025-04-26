// ignore_for_file: lines_longer_than_80_chars

import 'package:core/core.dart';

class PromptData {
  PromptData({
    required this.participants,
    required this.expenses,
    this.consumptions = const [],
    this.conditions = const [],
  });

  final List<Participant> participants;
  final List<Expense> expenses;
  final List<Consumption> consumptions;
  final List<String> conditions;

  PromptData copyWith({
    List<Participant>? participants,
    List<Expense>? expenses,
    List<Consumption>? consumptions,
    List<String>? conditions,
  }) =>
      PromptData(
        participants: participants ?? this.participants,
        expenses: expenses ?? this.expenses,
        consumptions: consumptions ?? this.consumptions,
        conditions: conditions ?? this.conditions,
      );

//   String toPrompt() {
//     final buffer = StringBuffer()
//       ..write('''
// I will provide you with the details of a gathering involving multiple people and their individual consumptions. I need you to automatically calculate how much each person should pay, based on what they consumed and what they already paid. Then, tell me who owes whom and how much.

// **Participants**:
// ${participants.map((e) => e.name).join(', ')}

// **Expenses**:
// ${expenses.map((e) => e.toString()).join(', ')}

// **Individual consumptions**:
// ''')
//       ..write(
//         consumptions.isEmpty
//             ? 'Everyone consumed everything.'
//             : consumptions.map((e) => e.toString()).join('.\n'),
//       )
//       ..write('''

// **Special conditions**:
// ''')
//       ..write(conditions.isEmpty ? 'None' : conditions.join('\n'))
//       ..write('''

// **Instructions**:
// - Split each item's cost only among the people who consumed it.
// - If no consumers are specified for an item, assume everyone consumed it.
// - Calculate how much each person *should* pay, how much they *actually* paid, and if they have credit or debt.
// - Calculate who owes whom and how much.
// - Exclude from debt anyone whose expenses were covered by others (e.g., if Nico covers Agus).
// - If there are no relevant notes or special comments, return `"notes": []`.
// - If a person is covered by someone else, their share of the expenses must be entirely paid by the covering person.
// - Do NOT assign any debt to the covered person.
// - Add the covered person's share to the payer's 'total' (but not to their 'paid' unless they actually paid for it).
// - Make sure this is reflected in the final debts and the notes.

// **IMPORTANT**:
// - Respect special conditions such as "X covers Y".
// - Y must not owe anything. All their share must be transferred to X's responsibility.
// - When calculating how much a person must pay, always compute the final numerical values.
// - Do NOT include expressions like "X + Y" or "A * B". Just return the actual result of the operation.
// - All monetary values must be resolved to plain numbers (e.g. 17450.0), not formulas.

// Respond **only** with a JSON object in the following structure:

// {
//   "summary": {
//     "total_spent": 0.0,
//     "persons": []
//   },
//   "by_person": [
//     { "name": "", "total": 0.0, "paid": 0.0 }
//   ],
//   "debts": [
//     { "debtor": "", "creditor": "", "amount": 0.0 }
//   ],
//   "notes": []
// }
// ''');

//     return buffer.toString();
//   }

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
        '- If there are no relevant notes or special comments, return `"notes": []`.',
      )
      ..writeln(
        '- If a person is covered by someone else, their share of the expenses must be entirely paid by the covering person.',
      )
      ..writeln('- Do NOT assign any debt to the covered person.')
      ..writeln(
        "- Do NOT add the covered person's share to the covering person's 'total'. Their 'total' must reflect only what they consumed.",
      )
      ..writeln(
        "- The covered person's expenses must be reflected in the 'debts' section under the covering person.",
      )
      ..writeln(
        '- Make sure this is reflected in the final debts and the notes.\n',
      )
      ..writeln('**IMPORTANT**:')
      ..writeln('- Respect special conditions such as "X covers Y".')
      ..writeln('- Y must not owe anything.')
      ..writeln("- All their share must be transferred to X's responsibility.")
      ..writeln(
        '- When calculating how much a person must pay, always compute the final numerical values.',
      )
      ..writeln(
        '- DO NOT infer or assume consumption unless explicitly stated. For each item, respect exactly who is listed as consumer. If a person did not consume an item, they must not pay for it in any way.',
      )
      ..writeln(
        '- Do NOT include expressions like "X + Y" or "A * B". Just return the actual result of the operation.',
      )
      ..writeln(
        '- All monetary values must be resolved to plain numbers (e.g. 17450.0), not formulas.',
      )
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
