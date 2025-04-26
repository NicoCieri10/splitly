import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:splitly/home/widget/widget.dart';
import 'package:splitly/widget/widget.dart';

class NewExpenseDialog extends StatefulWidget {
  const NewExpenseDialog({
    required this.participants,
    this.expense,
    super.key,
  });

  final List<Participant> participants;
  final Expense? expense;

  @override
  State<NewExpenseDialog> createState() => _NewExpenseDialogState();
}

class _NewExpenseDialogState extends State<NewExpenseDialog> {
  final _expenseController = TextEditingController();
  final _amountController = TextEditingController();

  Participant? _selectedParticipant;

  @override
  void initState() {
    super.initState();

    if (widget.expense == null) return;

    WidgetsBinding.instance.addPostFrameCallback(_loadExpenseData);
  }

  void _loadExpenseData(_) {
    final item = widget.expense?.name;
    final amount = widget.expense?.amount.toString();
    final participant = widget.expense?.paidBy;

    _expenseController.text = item ?? '';
    _amountController.text = amount ?? '';
    _selectedParticipant = participant;
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.participants
        .map(
          (item) => DropdownMenuItem(
            value: item,
            child: Text(item.name),
          ),
        )
        .toList();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: context.pop,
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Color.fromARGB(255, 71, 92, 103),
                      size: 20,
                    ),
                  ),
                  const TitleWidget('Nuevo gasto'),
                  const Gap(20),
                ],
              ),
              Gap(3.h),
              SubtitleWidget(
                'Ingresá el nombre del item: ',
                padding: EdgeInsets.symmetric(
                  vertical: 1.w,
                  horizontal: 4.5.w,
                ),
              ),
              CustomInput(
                controller: _expenseController,
                hint: 'Nombre',
              ),
              Gap(1.h),
              SubtitleWidget(
                'Ingresá el costo: ',
                padding: EdgeInsets.symmetric(
                  vertical: 1.w,
                  horizontal: 4.5.w,
                ),
              ),
              CustomInput.amount(
                controller: _amountController,
                hint: 'Costo',
              ),
              Gap(1.h),
              SubtitleWidget(
                'Seleccioná quién lo pagó: ',
                padding: EdgeInsets.symmetric(
                  vertical: 1.w,
                  horizontal: 4.5.w,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: DropdownButton(
                  items: items,
                  value: _selectedParticipant,
                  hint: const Text('Pagador'),
                  onChanged: _onParticipantChanged,
                ),
              ),
              Gap(5.h),
              CustomButton(
                text: 'Agregar',
                height: 5.h,
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.zero,
                onPressed: _onAddExpense,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onParticipantChanged(Participant? item) {
    if (item == null) return;

    setState(() => _selectedParticipant = item);
  }

  void _onAddExpense() {
    final name = _expenseController.text;
    final amount = double.tryParse(_amountController.text);
    final participant = _selectedParticipant;

    if (name.isEmpty || amount == null || participant == null) return;

    final expense = Expense(
      name: name,
      amount: amount,
      paidBy: participant,
    );

    context.pop(expense);
  }
}
