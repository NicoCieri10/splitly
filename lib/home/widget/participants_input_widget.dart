import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:splitly/widget/widget.dart';

class ParticipantsInputWidget extends StatelessWidget {
  const ParticipantsInputWidget({
    required this.participants,
    required this.onRemovePerson,
    required this.onAddPerson,
    super.key,
  });

  final List<Participant> participants;
  final void Function(Participant) onRemovePerson;
  final void Function(Participant) onAddPerson;

  @override
  Widget build(BuildContext context) {
    final items = participants.map(
      (person) => _PersonItem(
        person: person,
        onRemovePerson: onRemovePerson,
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.5.w),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 2.w,
              children: items.toList(),
            ),
          ),
          if (items.isNotEmpty) Gap(2.h),
          _PersonInput(onAddPerson: onAddPerson),
        ],
      ),
    );
  }
}

class _PersonInput extends StatelessWidget {
  const _PersonInput({required this.onAddPerson});

  final void Function(Participant) onAddPerson;

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    return Row(
      spacing: 3.w,
      children: [
        Expanded(
          child: CustomInput(
            controller: textController,
            label: 'Participantes',
            onFieldSubmitted: (text) => onAddPerson(
              Participant(name: text),
            ),
          ),
        ),
        IconButton.outlined(
          onPressed: () => onAddPerson(
            Participant(name: textController.text),
          ),
          style: ButtonStyle(
            side: WidgetStatePropertyAll(
              BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class _PersonItem extends StatelessWidget {
  const _PersonItem({
    required this.person,
    required this.onRemovePerson,
  });

  final Participant person;
  final void Function(Participant) onRemovePerson;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.sp),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            person.name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).canvasColor,
                ),
          ),
          Gap(2.w),
          InkWell(
            onTap: () => onRemovePerson(person),
            child: Icon(
              Icons.close,
              color: Theme.of(context).canvasColor,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
