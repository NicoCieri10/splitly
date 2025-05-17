import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:splitly/home/widget/widget.dart';
import 'package:splitly/widget/widget.dart';

class HomeInitialBody extends StatefulWidget {
  const HomeInitialBody({
    required this.onSendData,
    super.key,
  });

  final void Function(PromptData) onSendData;

  @override
  State<HomeInitialBody> createState() => _HomeInitialBodyState();
}

class _HomeInitialBodyState extends State<HomeInitialBody> {
  final _participants = <Participant>[];
  final _expenses = <Expense>[];
  final _consumptions = <Consumption>[];
  final _commentsController = TextEditingController();

  final mockData = PromptData(
    participants: [
      const Participant(name: 'Nico'),
      const Participant(name: 'Nahuel'),
      const Participant(name: 'Sol'),
    ],
    expenses: [
      const Expense(
        name: 'Ice cream',
        amount: 9200,
        paidBy: Participant(name: 'Sol'),
      ),
      const Expense(
        name: 'Meat',
        amount: 45600,
        paidBy: Participant(name: 'Nahuel'),
      ),
      const Expense(
        name: 'Wine',
        amount: 20067,
        paidBy: Participant(name: 'Nahuel'),
      ),
      const Expense(
        name: 'Beer',
        amount: 13770,
        paidBy: Participant(name: 'Nico'),
      ),
    ],
    consumptions: [
      const Consumption(
        expenses: [
          Expense(
            name: 'Ice cream',
            amount: 9200,
            paidBy: Participant(name: 'Sol'),
          ),
          Expense(
            name: 'Meat',
            amount: 45600,
            paidBy: Participant(name: 'Nahuel'),
          ),
        ],
        participant: Participant(name: 'Nahuel'),
      ),
      const Consumption(
        expenses: [
          Expense(
            name: 'Ice cream',
            amount: 9200,
            paidBy: Participant(name: 'Sol'),
          ),
          Expense(
            name: 'Meat',
            amount: 45600,
            paidBy: Participant(name: 'Nahuel'),
          ),
          Expense(
            name: 'Wine',
            amount: 20067,
            paidBy: Participant(name: 'Nahuel'),
          ),
          Expense(
            name: 'Beer',
            amount: 13770,
            paidBy: Participant(name: 'Nico'),
          ),
        ],
        participant: Participant(name: 'Sol'),
      ),
      const Consumption(
        expenses: [
          Expense(
            name: 'Ice cream',
            amount: 9200,
            paidBy: Participant(name: 'Sol'),
          ),
          Expense(
            name: 'Meat',
            amount: 45600,
            paidBy: Participant(name: 'Nahuel'),
          ),
          Expense(
            name: 'Wine',
            amount: 20067,
            paidBy: Participant(name: 'Nahuel'),
          ),
          Expense(
            name: 'Beer',
            amount: 13770,
            paidBy: Participant(name: 'Nico'),
          ),
        ],
        participant: Participant(name: 'Nico'),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final isValid = _participants.isNotEmpty && _expenses.isNotEmpty;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _FormBody(
          _FormBodyData(
            participants: _participants,
            expenses: _expenses,
            consumptions: _consumptions,
            commentsController: _commentsController,
            onAddPerson: _onAddPerson,
            onRemovePerson: _onRemovePerson,
            onAddExpense: _onAddExpense,
            onEditExpense: _onEditExpense,
            onRemoveExpense: _onRemoveExpense,
            onAddConsumption: _onAddConsumption,
            onRemoveConsumption: _onRemoveConsumption,
            onSendData: _onSendData,
            // onSendData: isValid ? _onSendData : null,
          ),
        ),
      ],
    );
  }

  void _onSendData() => widget.onSendData(
        PromptData(
          participants: mockData.participants,
          expenses: mockData.expenses,
          consumptions: mockData.consumptions,
          conditions: [],
        ),
        // PromptData(
        //   participants: _participants,
        //   expenses: _expenses,
        //   consumptions: _consumptions,
        //   conditions: [],
        // ),
      );

  void _onAddPerson(Participant person) {
    if (person.name.isEmpty) return;

    setState(() => _participants.add(person));
  }

  void _onRemovePerson(Participant person) {
    _participants.removeWhere((e) => e == person);

    // TODO(NicoCieri): check if there is any expense by [person]

    setState(() {});
  }

  void _onAddExpense(Expense expense) => setState(() => _expenses.add(expense));

  void _onEditExpense(Expense expense, Expense oldExpense) {
    _expenses
      ..remove(oldExpense)
      ..add(expense);

    setState(() {});
  }

  void _onRemoveExpense(Expense expense) =>
      setState(() => _expenses.remove(expense));

  void _onAddConsumption(Consumption consumption) {
    final oldConsumption = _consumptions
        .firstWhereOrNull((e) => e.participant == consumption.participant);

    if (oldConsumption?.expenses == consumption.expenses) return;

    if (oldConsumption == null) {
      _consumptions.add(consumption);
    } else {
      final i = _consumptions.indexOf(oldConsumption);
      _consumptions[i] = consumption;
    }

    setState(() {});
  }

  void _onRemoveConsumption(Consumption consumption) => setState(
        () => _consumptions.removeWhere(
          (e) => e.participant == consumption.participant,
        ),
      );
}

class _FormBody extends StatelessWidget {
  const _FormBody(this.formBodyData);

  final _FormBodyData formBodyData;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 1.h,
          children: [
            Gap(3.h),
            const TitleWidget('Participantes'),
            const SubtitleWidget('¿Quiénes participaron en la reunión?'),
            ParticipantsInputWidget(
              participants: formBodyData.participants,
              onAddPerson: formBodyData.onAddPerson,
              onRemovePerson: formBodyData.onRemovePerson,
            ),
            Gap(1.h),
            const TitleWidget('Gastos'),
            const SubtitleWidget('Agregá los gastos realizados.'),
            ExpensesInputWidget(
              expenses: formBodyData.expenses,
              participants: formBodyData.participants,
              onAddExpense: formBodyData.onAddExpense,
              onEditExpense: formBodyData.onEditExpense,
              onRemoveExpense: formBodyData.onRemoveExpense,
            ),
            Gap(1.h),
            const TitleWidget('Consumos'),
            const SubtitleWidget(
              // ignore: lines_longer_than_80_chars
              'Agregá los consumos realizados por persona.\nSi no se agrega un consumo, se asume que esa persona consumió todo.',
            ),
            ConsumptionsInputWidget(
              participants: formBodyData.participants,
              expenses: formBodyData.expenses,
              consumptions: formBodyData.consumptions,
              onAddConsumption: formBodyData.onAddConsumption,
              onRemoveConsumption: formBodyData.onRemoveConsumption,
            ),
            Gap(1.h),
            const TitleWidget('¿Algún comentario extra?'),
            const SubtitleWidget(
              // ignore: lines_longer_than_80_chars
              'Podés agregar alguna condición o comentario extra para tener en cuenta a la hora de repartir los gastos.\nEj.: Nico cubre los gastos de Agus',
            ),
            CommentsInputWidget(controller: formBodyData.commentsController),
            CustomButton(
              text: 'Enviar',
              margin: EdgeInsets.all(5.w),
              onPressed: formBodyData.onSendData,
            ),
          ],
        ),
      ),
    );
  }
}

class _FormBodyData {
  const _FormBodyData({
    required this.participants,
    required this.expenses,
    required this.consumptions,
    required this.onRemovePerson,
    required this.onAddPerson,
    required this.onAddExpense,
    required this.onEditExpense,
    required this.onRemoveExpense,
    required this.commentsController,
    required this.onAddConsumption,
    required this.onRemoveConsumption,
    this.onSendData,
  });

  final List<Participant> participants;
  final List<Expense> expenses;
  final List<Consumption> consumptions;
  final TextEditingController commentsController;
  final void Function(Participant) onRemovePerson;
  final void Function(Participant) onAddPerson;
  final void Function(Expense) onAddExpense;
  final void Function(Expense, Expense) onEditExpense;
  final void Function(Expense) onRemoveExpense;
  final void Function(Consumption) onAddConsumption;
  final void Function(Consumption) onRemoveConsumption;
  final void Function()? onSendData;
}
