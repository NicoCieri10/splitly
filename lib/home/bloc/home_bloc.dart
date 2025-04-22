import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<GenerateResponse>(
      (event, emit) async {
        try {
          final prompt = event.promptData;
          emit(HomeAttempting(promptData: prompt));

          final response = await AppRepository.getGenerativeResponse(prompt);

          if (response == null) throw Exception();

          emit(
            HomeSuccess(
              promptData: prompt,
              response: response,
            ),
          );
        } catch (e) {
          emit(HomeFailure(errorMessage: e.toString()));
        }
      },
    );

    on<NewRequest>(
      (event, emit) => emit(HomeInitial()),
    );
  }
}
