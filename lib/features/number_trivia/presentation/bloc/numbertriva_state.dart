part of 'numbertriva_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

}

class NumberTriviaInitial extends NumberTriviaState {
  const NumberTriviaInitial();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class NumberTriviaLoadingState extends NumberTriviaState{
  const NumberTriviaLoadingState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class NumberTriviaLoadedState extends NumberTriviaState {
  final NumberTriviaEntitie numberTrivia;
  const NumberTriviaLoadedState({
    required this.numberTrivia,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [numberTrivia];
}

class Error extends NumberTriviaState {
  final String message;
  Error({
    required this.message,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
