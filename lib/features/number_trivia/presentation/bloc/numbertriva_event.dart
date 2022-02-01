part of 'numbertriva_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

class ConcreteNumberTriviaGottenEvent extends NumberTriviaEvent {
  final String numberString;

  const ConcreteNumberTriviaGottenEvent({
    required this.numberString,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [numberString];
}

class RandomNumberTriviaGottenEvent extends NumberTriviaEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
