// ignore_for_file: lines_longer_than_80_chars

import 'package:core/core.dart';

class PromptData {
  PromptData({
    required this.participants,
    required this.expenses,
    this.consumptions = const [],
    this.conditions = const [],
  });

  factory PromptData.empty() => PromptData(
        participants: [],
        expenses: [],
      );

  final List<Participant> participants;
  final List<Expense> expenses;
  final List<Consumption> consumptions;
  // TODO(NicoCieri): implement conditions
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

  String toPrompt() {
    final expensesString = expenses.map((e) => '- $e').join('\n');

    final itemConsumers = <String, List<String>>{};
    for (final c in consumptions) {
      final consumerName = c.participant.name;
      for (final expense in c.expenses) {
        if (!itemConsumers.containsKey(expense.name)) {
          itemConsumers[expense.name] = [];
        }
        if (!itemConsumers[expense.name]!.contains(consumerName)) {
          itemConsumers[expense.name]!.add(consumerName);
        }
      }
    }

    final promptConsumptionLines = <String>[];
    itemConsumers.forEach(
      (itemName, consumers) => promptConsumptionLines.add(
        '$itemName: consumed by ${consumers.join(', ')}',
      ),
    );
    final consumptionsString = promptConsumptionLines.join('\n');

    // Ejemplo ilustrativo para guiar al LLM, adaptado a un caso simple:
    const example = '''
Ejemplo de cálculo paso a paso:

Participantes: Ana, Beto, Carla

Gastos:
- Pizza: 9000.0, paid by Ana
- Bebidas: 3000.0, paid by Beto

Consumos:
Pizza: consumed by Ana, Beto, Carla
Bebidas: consumed by Ana, Carla

Cálculos intermedios:
- Pizza: 9000.0 / 3 = 3000.0 por persona
- Bebidas: 3000.0 / 2 = 1500.0 por persona

Consumos individuales:
- Ana: 3000.0 (Pizza) + 1500.0 (Bebidas) = 4500.0
- Beto: 3000.0 (Pizza)
- Carla: 3000.0 (Pizza) + 1500.0 (Bebidas) = 4500.0

Sumas:
- Total gastado: 9000.0 + 3000.0 = 12000.0
- Total consumido: 4500.0 + 3000.0 + 4500.0 = 12000.0 (coincide)

Balances:
- Ana: pagó 9000.0, consumió 4500.0, balance = +4500.0
- Beto: pagó 3000.0, consumió 3000.0, balance = 0.0
- Carla: pagó 0.0, consumió 4500.0, balance = -4500.0

Deudas:
- Carla debe pagar 4500.0 a Ana

Formato de salida esperado (JSON):

{
  "summary": {
    "total_spent": 12000.0
  },
  "by_person": [
    {"name": "Ana", "total_consumed": 4500.0, "total_paid": 9000.0, "balance": 4500.0},
    {"name": "Beto", "total_consumed": 3000.0, "total_paid": 3000.0, "balance": 0.0},
    {"name": "Carla", "total_consumed": 4500.0, "total_paid": 0.0, "balance": -4500.0}
  ],
  "debts": [
    {"debtor": "Carla", "creditor": "Ana", "amount": 4500.0}
  ],
  "notes": []
}

----

Ahora, procesá los datos reales:

''';

    return '''
Eres un asistente inteligente especializado en calcular gastos compartidos y deudas entre grupos de personas. Tu tarea es procesar una lista de participantes, sus gastos y sus consumos individuales, luego calcular cuánto debe cada persona y determinar quién le debe a quién.

**Datos de entrada:**

* **Participantes**: Una lista separada por comas con todas las personas involucradas.  
  Ejemplo: `Juan, Maria, Pedro`

* **Gastos**: Una lista de gastos con el nombre del ítem, su costo total y quién lo pagó.  
  Formato: `[Nombre del ítem]: [Costo], paid by [Nombre del pagador]`  
  Ejemplo: `Pizza: 25000, paid by Juan`

* **Consumos por ítem**: Una lista que indica cada ítem y *todas* las personas que lo consumieron.  
  Formato: `[Nombre del ítem]: consumed by [Consumidor1], [Consumidor2], ...`  
  Ejemplo: `Pizza: consumed by Juan, Maria, Pedro`

* Importante:
- Si un ítem en la lista de `Gastos` no aparece en `Consumos por ítem`, significa que nadie lo consumió y su costo **no se distribuye**.
- Todos los valores monetarios deben calcularse con **máxima precisión**, usando punto decimal y redondeando a **dos decimales** si es necesario.
- Cada ítem debe dividirse **solo entre quienes lo consumieron**.
- La suma de todos los consumos individuales debe coincidir con el total gastado (de los ítems que tuvieron consumidores).

**Reglas de cálculo:**

1. **Distribución del costo por ítem**:  
   Para cada ítem, se divide su costo entre los consumidores listados.  
   Ejemplo: Si “Pizza” cuesta 9000 y fue consumida por 3 personas, cada una debe pagar 3000.

2. **Consumo total individual**:  
   Para cada persona, sumar todas sus participaciones individuales.  
   Esto da su `total_consumed`.

3. **Balance neto**:  
   Para cada persona: `balance = total_paid - total_consumed`.

4. **Resolución de deudas**:  
   - Las personas con `balance` negativo deben dinero.  
   - Las personas con `balance` positivo reciben dinero.  
   - Determinar la lista de deudas mínima que compense los saldos.

**Formato de salida (JSON):**

* Todos los valores monetarios deben estar como números (ejemplo: `17450.0`).
* La lista `by_person` debe estar ordenada alfabéticamente por nombre.
* El campo `notes` siempre debe estar vacío.

$example

Participants: ${participants.join(', ')}

Expenses:
$expensesString

Consumptions:
$consumptionsString
''';
  }

//   String toPrompt() {
//     final expensesString = expenses.map((e) => '- $e').join('\n');
//     // final consumptionsString = consumptions.map((c) => '- $c').join('\n');

//     // PASO 1: Procesar tus consumptions para obtener la estructura "por ítem"
//     final itemConsumers = <String, List<String>>{};

//     for (final c in consumptions) {
//       final consumerName = c.participant.name;
//       for (final expense in c.expenses) {
//         if (!itemConsumers.containsKey(expense.name)) {
//           itemConsumers[expense.name] = [];
//         }
//         if (!itemConsumers[expense.name]!.contains(consumerName)) {
//           itemConsumers[expense.name]!.add(consumerName);
//         }
//       }
//     }

//     // PASO 2: Generar la cadena de texto para el prompt
//     final promptConsumptionLines = <String>[];
//     itemConsumers.forEach(
//       (itemName, consumers) => promptConsumptionLines.add(
//         '$itemName: consumed by ${consumers.join(', ')}',
//       ),
//     );

//     final consumptionsString = promptConsumptionLines.join('\n');

//     return '''
// Eres un asistente inteligente especializado en calcular gastos compartidos y deudas entre grupos de personas. Tu tarea es procesar una lista de participantes, sus gastos y sus consumos individuales, luego calcular cuánto debe cada persona y determinar quién le debe a quién.

// **Datos de entrada:**

// * **Participantes**: Una lista separada por comas con todas las personas involucradas.
//   Ejemplo: `Juan, Maria, Pedro`

// * **Gastos**: Una lista de gastos con el nombre del ítem, su costo total y quién lo pagó.
//   Formato: `[Nombre del ítem]: [Costo], paid by [Nombre del pagador]`
//   Ejemplo: `Pizza: 25000, paid by Juan`

// * **Consumos por ítem**: Una lista que indica cada ítem y *todas* las personas que lo consumieron.
//   Formato: `[Nombre del ítem]: consumed by [Consumidor1], [Consumidor2], ...`
//   Ejemplo: `Pizza: consumed by Juan, Maria, Pedro`

// * Importante:
// - Si un ítem en la lista de `Gastos` no aparece en `Consumos por ítem`, significa que nadie lo consumió y su costo **no se distribuye**.
// - Todos los valores monetarios deben calcularse con **máxima precisión**, usando punto decimal y redondeando a **dos decimales** si es necesario.
// - Cada ítem debe dividirse **solo entre quienes lo consumieron**.
// - La suma de todos los consumos individuales debe coincidir con el total gastado (de los ítems que tuvieron consumidores).

// **Reglas de cálculo:**

// 1. **Distribución del costo por ítem**:
//    Para cada ítem, se divide su costo entre los consumidores listados.
//    Ejemplo: Si “Pizza” cuesta 9000 y fue consumida por 3 personas, cada una debe pagar 3000.

// 2. **Consumo total individual**:
//    Para cada persona, sumar todas sus participaciones individuales.
//    Esto da su `total_consumed`.

// 3. **Balance neto**:
//    Para cada persona: `balance = total_paid - total_consumed`.

// 4. **Resolución de deudas**:
//    - Las personas con `balance` negativo deben dinero.
//    - Las personas con `balance` positivo reciben dinero.
//    - Determinar la lista de deudas mínima que compense los saldos.

// **Formato de salida (JSON):**

// * Todos los valores monetarios deben estar como números (ejemplo: `17450.0`).
// * La lista `by_person` debe estar ordenada alfabéticamente por nombre.
// * El campo `notes` siempre debe estar vacío.
// * Antes de calcular balances o deudas, listá cada ítem, su costo, y a cuánto equivale por consumidor. Luego listá los consumos individuales de cada persona. Verificá que la suma de todos los consumos coincida con la suma de los ítems con consumidores.

// ```json
// {
//   "summary": {
//     "total_spent": 0.0
//   },
//   "by_person": [
//     {
//       "name": "string",
//       "total_consumed": 0.0,
//       "total_paid": 0.0,
//       "balance": 0.0
//     }
//   ],
//   "debts": [
//     {
//       "debtor": "string",
//       "creditor": "string",
//       "amount": 0.0
//     }
//   ],
//   "notes": []
// }

// Participants: ${participants.join(', ')}

// Expenses:
// $expensesString

// Consumptions:
// $consumptionsString
// ''';

//     return '''
// You are an intelligent assistant specialized in calculating shared expenses and debts for groups of people. Your task is to process a list of participants, their expenses, and their individual consumptions, then calculate the total owed by each person and determine who owes whom.

// **Input Data:**

// * **Participants**: A comma-separated list of all individuals involved.
//     Example: `Juan, Maria, Pedro`
// * **Expenses**: A list of expenses incurred, specifying the item, its total cost, and who paid for it.
//     Format: `[Item Name]: [Cost], paid by [Payer Name]`
//     Example: `Pizza: 25000, paid by Juan`, `Drinks: 12000, paid by Maria`
// * **Consumptions by Item**: A list specifying each item and *all* participants who consumed it.
//     Format: `[Item Name]: consumed by [Consumer1], [Consumer2], ...`
//     Example: `Pizza: consumed by Juan, Maria, Pedro`, `Drinks: consumed by Juan, Maria`
//     * **Important**: If an item from `Expenses` is not listed here, it means no one consumed it (and its cost will not be distributed).

// **Calculation Rules:**

// 1.  **Item Cost Distribution**: For each item in the `Expenses` list, identify its consumers from `Consumptions by Item`. Divide the item's `total_cost` by the `number of consumers` for that item. This result is the `share per consumer` for that specific item.
//     * **Example Calculation for Item X**: If Item X costs 100 and is consumed by 2 people (A, B), then Person A's share from Item X is 100 / 2 = 50. Person B's share from Item X is 100 / 2 = 50.
// 2.  **Individual Total Consumption**: For each person, sum up *all their individual shares* from all items they are listed as a consumer. This sum is their `total_consumed` (what they *should* pay).
//     * **Example Calculation for Person Y**: If Person Y consumed Item X (share 50) and Item Z (share 30), their total_consumed is 50 + 30 = 80.
// 3.  **Net Balance**: For each person, calculate their net balance: `(total_paid - total_consumed)`.
// 4.  **Debt Resolution**: Based on net balances, determine who owes whom and the exact amount, ensuring the minimum number of transactions.

// **Output Format (JSON):**

// * All monetary values must be resolved to plain numerical values (e.g., `17450.0`), not formulas or expressions like "X + Y".
// * Sort the `by_person` list alphabetically by name.
// * The `notes` array should always be empty: `"notes": []`.

// ```json
// {
//   "summary": {
//     "total_spent": 0.0
//   },
//   "by_person": [
//     {
//       "name": "string",
//       "total_consumed": 0.0,
//       "total_paid": 0.0,
//       "balance": 0.0
//     }
//   ],
//   "debts": [
//     {
//       "debtor": "string",
//       "creditor": "string",
//       "amount": 0.0
//     }
//   ],
//   "notes": []
// }

// Participants: ${participants.join(', ')}

// Expenses:
// $expensesString

// Consumptions:
// $consumptionsString
// ''';
//   }

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

  // String toPrompt() {
  //   final buffer = StringBuffer()
  //     ..writeln(
  //       'I will provide you with the details of a gathering involving multiple people and their individual consumptions. I need you to automatically calculate how much each person should pay, based on what they consumed and what they already paid. Then, tell me who owes whom and how much.\n',
  //     )
  //     ..writeln('**Participants**:\n${participants.join(', ')}\n')
  //     ..writeln(
  //       '**Expenses**:\n${expenses.map((e) => e.toString()).join(', ')}\n',
  //     )
  //     ..writeln('**Individual consumptions**:');

  //   consumptions.isEmpty
  //       ? buffer.writeln('Everyone consumed everything.')
  //       : consumptions.forEach(buffer.writeln);

  //   buffer
  //     ..writeln()
  //     ..writeln('**Special conditions**:');

  //   conditions.isEmpty
  //       ? buffer.writeln('None')
  //       : conditions.forEach(buffer.writeln);

  //   buffer
  //     ..writeln()
  //     ..writeln('**Instructions**:')
  //     ..writeln(
  //       "- Split each item's cost only among the people who consumed it.",
  //     )
  //     ..writeln(
  //       '- If no consumers are specified for an item, assume everyone consumed it.',
  //     )
  //     ..writeln(
  //       '- Calculate how much each person *should* pay, how much they *actually* paid, and if they have credit or debt.',
  //     )
  //     ..writeln('- Calculate who owes whom and how much.')
  //     ..writeln(
  //       '- Exclude from debt anyone whose expenses were covered by others (e.g., if Nico covers Agus).',
  //     )
  //     ..writeln('- Sort the `by_person` list alphabetically by name.')
  //     ..writeln(
  //       '- If there are no relevant notes or special comments, return `"notes": []`.',
  //     )
  //     ..writeln(
  //       '- If a person is covered by someone else, their share of the expenses must be entirely paid by the covering person.',
  //     )
  //     ..writeln('- Do NOT assign any debt to the covered person.')
  //     ..writeln(
  //       "- Do NOT add the covered person's share to the covering person's 'total'. Their 'total' must reflect only what they consumed.",
  //     )
  //     ..writeln(
  //       "- The covered person's expenses must be reflected in the 'debts' section under the covering person.",
  //     )
  //     ..writeln(
  //       '- Make sure this is reflected in the final debts and the notes.\n',
  //     )
  //     ..writeln('**IMPORTANT**:')
  //     ..writeln('- Respect special conditions such as "X covers Y".')
  //     ..writeln('- Y must not owe anything.')
  //     ..writeln("- All their share must be transferred to X's responsibility.")
  //     ..writeln(
  //       '- When calculating how much a person must pay, always compute the final numerical values.',
  //     )
  //     ..writeln(
  //       '- DO NOT infer or assume consumption unless explicitly stated. For each item, respect exactly who is listed as consumer. If a person did not consume an item, they must not pay for it in any way.',
  //     )
  //     ..writeln(
  //       '- Do NOT include expressions like "X + Y" or "A * B". Just return the actual result of the operation.',
  //     )
  //     ..writeln(
  //       '- All monetary values must be resolved to plain numbers (e.g. 17450.0), not formulas.',
  //     )
  //     ..writeln(
  //       'Respond **only** with a JSON object in the following structure:\n',
  //     )
  //     ..writeln(
  //       '{\n'
  //       '  "summary": {\n'
  //       '    "total_spent": 0.0,\n'
  //       '    "persons": []\n'
  //       '  },\n'
  //       '  "by_person": [\n'
  //       '    { "name": "", "total": 0.0, "paid": 0.0 }\n'
  //       '  ],\n'
  //       '  "debts": [\n'
  //       '    { "debtor": "", "creditor": "", "amount": 0.0 }\n'
  //       '  ],\n'
  //       '  "notes": []\n'
  //       '}\n',
  //     );

  // return buffer.toString();
  // }
}
