import 'package:core/core.dart';

class PromptUtils {
  static String generarPrompt({required PromptData data}) {
    return '''
I will provide you with the details of a gathering involving multiple people and their individual consumptions. I need you to automatically calculate how much each person should pay, based on what they consumed and what they already paid. Then, tell me who owes whom and how much.

**Participants**:  
{{participants}}  
Example: Nico, Agus, Nahuel, Juli, Sol

**Expenses**:  
{{expenses}}  
Example: Meat: 45600-Nahuel, Beer: 13770-Nico, Ice cream: 9200-Sol

**Individual consumptions**:  
{{consumptions}}  
Example: Nico, Agus and Nahuel consumed everything.  
Juli didn't consume wine.  
Sol didn't consume ice cream.

**Special conditions**:  
{{conditions}}  
Example: Nico covers Agus's expenses

**Instructions**:
- Split each item's cost only among the people who consumed it.
- If no consumers are specified for an item, assume everyone consumed it.
- Calculate how much each person *should* pay, how much they *actually* paid, and if they have credit or debt.
- Calculate who owes whom and how much.
- Exclude from debt anyone whose expenses were covered by others (e.g., if Nico covers Agus).
- Sort the `by_person` list alphabetically by name.
- If there are no relevant notes or special comments, return `"notes": []`.

**IMPORTANT**:  
Respond **only** with a JSON object in the following structure:

{
  "summary": {
    "total_spent": 88637.0,
    "persons": ["Agus", "Juli", "Nahuel", "Nico", "Sol"]
  },
  "by_person": [
    { "name": "Agus", "total": 19625.9, "paid": 0.0 },
    { "name": "Juli", "total": 16876.9, "paid": 0.0 },
    { "name": "Nahuel", "total": 19625.9, "paid": 56600.0 },
    { "name": "Nico", "total": 19625.9, "paid": 32037.0 },
    { "name": "Sol", "total": 12883.4, "paid": 0.0 }
  ],
  "debts": [
    { "debtor": "Nico", "creditor": "Nahuel", "amount": 7214.8 },
    { "debtor": "Juli", "creditor": "Nahuel", "amount": 16876.9 },
    { "debtor": "Sol", "creditor": "Nahuel", "amount": 12883.4 }
  ],
  "notes": ["Agus is covered by Nico", "Nahuel already paid all necessary expenses"]
}
''';
  }
}
