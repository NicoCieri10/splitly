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
    void onSendData(PromptData data) => context.read<HomeBloc>().add(
          GenerateResponse(data),
        );

    void onNewRequest() => context.read<HomeBloc>().add(
          const NewRequest(),
        );

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Splitly'),
          centerTitle: true,
        ),
        body: BlocConsumer<HomeBloc, HomeState>(
          listener: homeListener,
          builder: (context, state) => switch (state) {
            HomeInitial() => HomeInitialBody(onSendData: onSendData),
            HomeAttempting() => const LoadingWidget(),
            HomeSuccess() => HomeSuccessBody(
                response: state.response,
                promptData: state.promptData ?? PromptData.empty(),
                onNewRequest: onNewRequest,
              ),
            HomeFailure() => const SizedBox(),
          },
        ),
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
