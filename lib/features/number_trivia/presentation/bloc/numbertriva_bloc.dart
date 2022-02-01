import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_number_trivia_app/core/error/failure.dart';
import 'package:tdd_number_trivia_app/core/util/input_converter.dart';

import 'package:tdd_number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/domain/usecases/get_concret_number_trivia.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'numbertriva_event.dart';
part 'numbertriva_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  late final GetConcretNumberTrivia concreteTriviaUseCase;
  late final GetRandomNumberTrivia randomTriviaUseCase;
  NumberTriviaBloc(
      {required GetConcretNumberTrivia concrete,
      required GetRandomNumberTrivia random})
      : super(const NumberTriviaInitial()) {
    concreteTriviaUseCase = concrete;
    randomTriviaUseCase = random;

    on<ConcreteNumberTriviaGottenEvent>((event, emit) {
      final number =
          InputConverter.convertStringToUnsignedInteger(event.numberString);
      print(number);
      // if(number.isLeft()){
      //   emit(Error(message: 'this forks'));
      // }else{
      //   final either = await concreteTriviaUseCase.exec(number.getOrElse(() => 99));
      //   either!.fold((l) => emit(Error(message: failMessage(l))), (r) =>emit(NumberTriviaLoadedState(numberTrivia: r)));
      // }
      number.fold(
        failurSit
          ,
          numberSit
          );
    });

    on<RandomNumberTriviaGottenEvent>((event, emit) async {
      emit(NumberTriviaLoadingState());
      final either = await randomTriviaUseCase.getRandomNumberTrivia();
      either!.fold((l) => emit(Error(message: failMessage(l))),
          (r) => emit(NumberTriviaLoadedState(numberTrivia: r)));
    });
  }
  failurSit(Failure failure){
    emit(Error(message: failMessage(failure)));
  }
  numberSit(int number) async {
        emit(NumberTriviaLoadingState());
        final either = await concreteTriviaUseCase.exec(number);
        // triviaOrFail(either,emit);
        // triviaOrFailure(either!);
        // // yield
        either!.fold(
            (serverFailure) => emit(Error(message: failMessage(serverFailure))),
            (numberTrivia) =>
                emit(NumberTriviaLoadedState(numberTrivia: numberTrivia)));
      
  }
  Stream<NumberTriviaState> triviaOrFailure(
      Either<Failure, NumberTriviaEntitie> either) async* {
    yield await either.fold((failure) => Error(message: failMessage(failure)),
        (numberTrivia) => NumberTriviaLoadedState(numberTrivia: numberTrivia));
  }

  Stream<NumberTriviaState> triviaOrFail(
      Either<Failure, NumberTriviaEntitie>? either,
      Emitter<NumberTriviaState> emit) async* {
    either!.fold((l) => emit(Error(message: failMessage(l))),
        (r) => emit(NumberTriviaLoadedState(numberTrivia: r)));
  }

  String failMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      case CahceFailure:
        return 'Cache Failure';
      default:
        return 'unexpected failure';
    }
  }
}
