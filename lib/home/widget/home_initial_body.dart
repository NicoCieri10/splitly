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
  final _consumptions = <String>[];
  final _commentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final data = PromptData(
    //   participants: [
    //     const Participant(name: 'Nico'),
    //     const Participant(name: 'Agus'),
    //     const Participant(name: 'Juli'),
    //     const Participant(name: 'Nahuel'),
    //     const Participant(name: 'Sol'),
    //   ],
    //   expenses: [
    //     const Expense(name: 'Ice cream', amount: 9200, paidBy: 'Sol'),
    //     const Expense(name: 'Meat', amount: 45600, paidBy: 'Nahuel'),
    //     const Expense(name: 'Wine', amount: 20067, paidBy: 'Nahuel'),
    //     const Expense(name: 'Beer', amount: 13770, paidBy: 'Nico'),
    //   ],
    //   consumptions: [
    //     "Juli didn't consume wine",
    //     "Sol didn't consume ice cream",
    //   ],
    //   conditions: ["Nico covers Agus's expenses"],
    // );
    final isValid = _participants.isNotEmpty &&
        _expenses.isNotEmpty &&
        _consumptions.isNotEmpty;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _FormBody(
          participants: _participants,
          expenses: _expenses,
          onAddPerson: _onAddPerson,
          onRemovePerson: _onRemovePerson,
          onAddExpense: _onAddExpense,
          onRemoveExpense: _onRemoveExpense,
          onSendData: isValid ? _onSendData : null,
          commentsController: _commentsController,
        ),
      ],
    );
  }

  void _onSendData() => widget.onSendData(
        PromptData(
          participants: _participants,
          expenses: _expenses,
          conditions: [],
          consumptions: [],
        ),
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

  void _onRemoveExpense(Expense expense) =>
      setState(() => _expenses.removeWhere((e) => e == expense));
}

class _FormBody extends StatelessWidget {
  const _FormBody({
    required this.participants,
    required this.expenses,
    required this.onRemovePerson,
    required this.onAddPerson,
    required this.onAddExpense,
    required this.onRemoveExpense,
    required this.commentsController,
    this.onSendData,
  });

  final List<Participant> participants;
  final List<Expense> expenses;
  final void Function(Participant) onRemovePerson;
  final void Function(Participant) onAddPerson;
  final void Function(Expense) onAddExpense;
  final void Function(Expense) onRemoveExpense;
  final void Function()? onSendData;
  final TextEditingController commentsController;

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
              participants: participants,
              onAddPerson: onAddPerson,
              onRemovePerson: onRemovePerson,
            ),
            Gap(1.h),
            const TitleWidget('Gastos'),
            const SubtitleWidget('Agregá los gastos realizados.'),
            ExpensesInputWidget(
              expenses: expenses,
              participants: participants,
              onAddExpense: onAddExpense,
              onRemoveExpense: onRemoveExpense,
            ),
            Gap(1.h),
            const TitleWidget('Consumos'),
            const SubtitleWidget(
              // ignore: lines_longer_than_80_chars
              'Agregá los consumos realizados por persona.\nSi no se agrega un consumo, se asume que esa persona consumió todo.',
            ),
            Gap(1.h),
            const TitleWidget('¿Algún comentario extra?'),
            const SubtitleWidget(
              // ignore: lines_longer_than_80_chars
              'Podés agregar alguna condición o comentario extra para tener en cuenta a la hora de repartir los gastos.\nEj.: Nico cubre los gastos de Agus',
            ),
            CommentsInputWidget(
              controller: commentsController,
            ),
            CustomButton(
              text: 'Enviar',
              margin: EdgeInsets.all(5.w),
              onPressed: onSendData,
            ),
          ],
        ),
      ),
    );
  }
}
