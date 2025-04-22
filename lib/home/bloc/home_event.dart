part of 'home_bloc.dart';

@immutable
sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class GenerateResponse extends HomeEvent {
  const GenerateResponse(this.promptData);

  final PromptData promptData;
}

class NewRequest extends HomeEvent {
  const NewRequest();
}
