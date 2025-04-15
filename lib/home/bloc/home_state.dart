part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {
  HomeInitial({this.promptData});

  final PromptData? promptData;
}

final class HomeAttempting extends HomeState {
  HomeAttempting({this.promptData});

  final PromptData? promptData;
}

final class HomeSuccess extends HomeState {
  HomeSuccess({
    this.promptData,
    this.response,
  });

  final PromptData? promptData;
  final GenerativeResponse? response;
}

final class HomeFailure extends HomeState {
  HomeFailure({
    this.promptData,
    this.errorMessage = '',
  });

  final PromptData? promptData;
  final String errorMessage;
}
