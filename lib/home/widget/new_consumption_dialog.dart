import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:splitly/home/widget/widget.dart';
import 'package:splitly/widget/widget.dart';

enum _NewConsumptionViews {
  participant,
  expenses;
}

class NewConsumptionDialog extends StatefulWidget {
  const NewConsumptionDialog({
    required this.expenses,
    required this.participants,
    required this.consumptions,
    super.key,
  });

  final List<Participant> participants;
  final List<Expense> expenses;
  final List<Consumption> consumptions;

  @override
  State<NewConsumptionDialog> createState() => _NewConsumptionDialogState();
}

class _NewConsumptionDialogState extends State<NewConsumptionDialog> {
  Participant? _participant;
  final _expensesMap = <Expense, bool>{};

  _NewConsumptionViews _view = _NewConsumptionViews.participant;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_initExpensesMap);
  }

  @override
  Widget build(BuildContext context) {
    return switch (_view) {
      _NewConsumptionViews.participant => _ParticipantWidget(
          participants: widget.participants,
          personSelected: _participant,
          onPersonSelected: _onPersonSelected,
        ),
      _NewConsumptionViews.expenses => _ExpensesWidget(
          expenses: _expensesMap,
          consumptions: widget.consumptions,
          participant: _participant!,
          onExpenseChanged: _onExpenseChanged,
          onBack: _onBack,
          onContinue: _onContinue,
        ),
    };
  }

  void _initExpensesMap(_) {
    for (final expense in widget.expenses) {
      _expensesMap.update(
        expense,
        (_) => false,
        ifAbsent: () => false,
      );
    }
  }

  void _onPersonSelected(Participant person) {
    final consumption =
        widget.consumptions.firstWhereOrNull((e) => e.participant == person);

    if (consumption != null) {
      for (final expense in consumption.expenses) {
        _expensesMap.update(expense, (_) => true);
      }
    }

    _participant = person;
    _view = _NewConsumptionViews.expenses;

    setState(() {});
  }

  void _onExpenseChanged({
    required Expense expense,
    required bool value,
  }) =>
      setState(
        () => _expensesMap.update(
          expense,
          (_) => value,
        ),
      );

  void _onBack() {
    _initExpensesMap(0);
    setState(() => _view = _NewConsumptionViews.participant);
  }

  void _onContinue() {
    final expenses = <Expense>[];

    for (final element in _expensesMap.entries) {
      if (!element.value) continue;

      expenses.add(element.key);
    }

    if (expenses.isEmpty || _participant == null) return;

    context.pop(
      Consumption(
        expenses: expenses,
        participant: _participant!,
      ),
    );
  }
}

class _ParticipantWidget extends StatelessWidget {
  const _ParticipantWidget({
    required this.participants,
    required this.personSelected,
    required this.onPersonSelected,
  });

  final List<Participant> participants;
  final Participant? personSelected;
  final void Function(Participant) onPersonSelected;

  @override
  Widget build(BuildContext context) {
    final items = participants
        .map(
          (person) => _PersonItem(
            person,
            onPressed: onPersonSelected,
            isSelected: personSelected == person,
          ),
        )
        .toList();

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _HeaderWidget(title: 'Participante'),
            Gap(2.5.h),
            Container(
              constraints: BoxConstraints(maxHeight: 40.h),
              child: SingleChildScrollView(
                child: Column(children: items),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpensesWidget extends StatelessWidget {
  const _ExpensesWidget({
    required this.expenses,
    required this.consumptions,
    required this.participant,
    required this.onBack,
    required this.onContinue,
    required this.onExpenseChanged,
  });

  final Map<Expense, bool> expenses;
  final List<Consumption> consumptions;
  final Participant participant;
  final VoidCallback onBack;
  final VoidCallback onContinue;
  final void Function({
    required Expense expense,
    required bool value,
  }) onExpenseChanged;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    for (final expense in expenses.keys) {
      final index = expenses.keys.toList().indexOf(expense);
      final value = expenses.values.toList()[index];

      items.add(
        CheckboxListTile(
          value: value,
          title: Text(expense.name),
          onChanged: (value) => onExpenseChanged(
            expense: expense,
            value: value ?? false,
          ),
        ),
      );
    }

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderWidget(
              title: 'Consumos',
              onBack: onBack,
            ),
            Container(
              constraints: BoxConstraints(maxHeight: 40.h),
              padding: EdgeInsets.symmetric(vertical: 2.5.h),
              child: SingleChildScrollView(
                child: Column(children: items),
              ),
            ),
            CustomButton(
              text: 'Continuar',
              height: 5.h,
              padding: const EdgeInsets.all(10),
              margin: EdgeInsets.zero,
              onPressed: onContinue,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({
    required this.title,
    this.onBack,
  });

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: onBack != null,
          replacement: const Gap(20),
          child: InkWell(
            onTap: onBack,
            child: const Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 71, 92, 103),
              size: 20,
            ),
          ),
        ),
        TitleWidget(title),
        InkWell(
          onTap: context.pop,
          child: const Icon(
            Icons.close,
            color: Color.fromARGB(255, 71, 92, 103),
            size: 20,
          ),
        ),
      ],
    );
  }
}

class _PersonItem extends StatelessWidget {
  const _PersonItem(
    this.person, {
    required this.onPressed,
    this.isSelected = false,
  });

  final Participant person;
  final void Function(Participant) onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(person),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.sp),
        child: Row(
          children: [
            CircleAvatar(
              child: Icon(
                Icons.person,
                size: 20.sp,
              ),
            ),
            const Spacer(),
            Flexible(
              flex: 10,
              child: Text(
                person.name,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
