import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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

    Future<void> onNewRequest() async {
      final newRequest = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Nueva consulta'),
          content: const Text('¿Desea realizar una nueva consulta?'),
          actions: [
            TextButton(
              onPressed: context.pop,
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => context.pop(true),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );

      if (newRequest != true || !context.mounted) return;

      context.read<HomeBloc>().add(
            const NewRequest(),
          );
    }

    void onGetBack() => context.read<HomeBloc>().add(
          const NewRequest(),
        );

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Splitly',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
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
            HomeFailure() => Center(
                child: TextButton(
                  onPressed: onGetBack,
                  child: const Text('Volver'),
                ),
              ),
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
