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
    final data = PromptData(
      participants: ['Nico', 'Agus', 'Nahuel', 'Juli', 'Sol'],
      expenses: [
        const Expense(name: 'Meat', amount: 45600, paidBy: 'Nahuel'),
        const Expense(name: 'Beer', amount: 13770, paidBy: 'Nico'),
        const Expense(name: 'Ice cream', amount: 9200, paidBy: 'Sol'),
        const Expense(name: 'Wine', amount: 20067, paidBy: 'Nahuel'),
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.gesture_outlined),
        onPressed: () => context.read<HomeBloc>().add(
              GenerateResponse(data),
            ),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            HomeInitial() => const _HomeInitialBody(),
            HomeAttempting() => const LoadingWidget(),
            HomeSuccess() => _HomeSuccessBody(state.response),
            HomeFailure() => const _HomeInitialBody(),
          };
        },
      ),
    );
  }
}

class _HomeInitialBody extends StatelessWidget {
  const _HomeInitialBody();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('HomePage'),
    );
  }
}

class _HomeSuccessBody extends StatelessWidget {
  const _HomeSuccessBody(this.response);

  final GenerativeResponse? response;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            response?.summary?.totalSpent.toString() ?? 'N/D',
          ),
          Text(
            response?.summary?.persons.toString() ?? 'N/D',
          ),
          Text(
            response?.byPerson.toString() ?? 'N/D',
          ),
        ],
      ),
    );
  }
}
