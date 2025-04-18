import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitly/home/bloc/home_bloc.dart';
import 'package:splitly/home/widget/widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const route = '/home';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final sendData = PromptData(
      participants: ['Nico', 'Agus', 'Nahuel', 'Juli', 'Sol'],
      expenses: [
        const Expense(name: 'Ice cream', amount: 9200, paidBy: 'Sol'),
        const Expense(name: 'Meat', amount: 45600, paidBy: 'Nahuel'),
        const Expense(name: 'Wine', amount: 20067, paidBy: 'Nahuel'),
        const Expense(name: 'Beer', amount: 13770, paidBy: 'Nico'),
      ],
      consumptions: [
        "Juli didn't consume wine",
        "Sol didn't consume ice cream",
      ],
      conditions: ["Nico covers Agus's expenses"],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Splitly'),
        centerTitle: true,
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.gesture_outlined),
      //   onPressed: () => context.read<HomeBloc>().add(
      //         GenerateResponse(sendData),
      //       ),
      // ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: homeListener,
        builder: (context, state) => switch (state) {
          HomeInitial() => const HomeInitialBody(),
          HomeAttempting() => const LoadingWidget(),
          HomeSuccess() => HomeSuccessBody(state.response),
          HomeFailure() => const HomeInitialBody(),
        },
      ),
    );
  }

  void homeListener(BuildContext context, HomeState state) {
    if (state is HomeFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
