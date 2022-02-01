import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_number_trivia_app/core/error/failure.dart';
import 'package:tdd_number_trivia_app/core/util/input_converter.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/domain/usecases/get_concret_number_trivia.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/presentation/bloc/numbertriva_bloc.dart';
import './numbertrivia_bloc_test.mocks.dart';

@GenerateMocks([
  GetConcretNumberTrivia,
  GetRandomNumberTrivia,
])
main() {
  late NumberTriviaBloc triviaBloc;
  late MockGetConcretNumberTrivia concretNumberTriviaUseCase;
  late MockGetRandomNumberTrivia randomNumberTriviaUseCase;
  setUp(() {
    concretNumberTriviaUseCase = MockGetConcretNumberTrivia();
    randomNumberTriviaUseCase = MockGetRandomNumberTrivia();

    triviaBloc = NumberTriviaBloc(
        concrete: concretNumberTriviaUseCase,
        random: randomNumberTriviaUseCase);
  });
  test('initialState should be NumberTriviaInitial', () {
    expect(triviaBloc.state, equals(NumberTriviaInitial()));
  });
  // test('should call inputConverter', (){
  //   //
  //   triviaBloc.add(ConcreteNumberTriviaGottenEvent(numberString: '12'));

  //   //

  // });
  group('concreteNumber Event', () {
    final testNumberString = '123';
    final failTestNumberString = 'aaa2';
    final testNumber = 123;
    final testNumberTriviaEntitie =
        NumberTriviaEntitie(text: 'this is test', number: testNumber);
    final loadedState =
        NumberTriviaLoadedState(numberTrivia: testNumberTriviaEntitie);

    // test('should call InputConverter', (){
    //   //act
    //   triviaBloc.add(ConcreteNumberTriviaGottenEvent(numberString: testNumberString));
    //   //
    //   verify(InputConverter.convertStringToUnsignedInteger(testNumberString));

    // });

    test('should return Error State', () {
      //arrange
      when(concretNumberTriviaUseCase.exec(testNumber))
          .thenAnswer((realInvocation) async => Right(testNumberTriviaEntitie));
      //assert
      expectLater(
          triviaBloc.stream,
          emitsInOrder([
            
            Error(message: 'Input Conversion did not complete succesfully')
          ]));
      // act
      triviaBloc.add(
          ConcreteNumberTriviaGottenEvent(numberString: failTestNumberString));
    });
    test('should return Loading State', () {
      //arrange
      when(concretNumberTriviaUseCase.exec(testNumber))
          .thenAnswer((realInvocation) async => Right(testNumberTriviaEntitie));
      //assert
      expectLater(
          triviaBloc.stream,
          emitsInOrder([
            NumberTriviaLoadingState(),
            NumberTriviaLoadedState(numberTrivia: testNumberTriviaEntitie)
          ]));
      // act
      triviaBloc.add(
          ConcreteNumberTriviaGottenEvent(numberString: testNumberString));
    });
    test('should return [Loading,Error] State when usecase returns an error', () {
      //arrange
      when(concretNumberTriviaUseCase.exec(testNumber))
          .thenAnswer((realInvocation) async => Left(ServerFailure(properties: [])));
      //assert
      expectLater(
          triviaBloc.stream,
          emitsInOrder([
            NumberTriviaLoadingState(),
            Error(message: 'something went wrong')
          ]));
      // act
      triviaBloc.add(
          ConcreteNumberTriviaGottenEvent(numberString: testNumberString));
    });
  });
  group('randomNumber Event', (){
    final testNumber = 123;
    final testNumberTriviaEntitie =
        NumberTriviaEntitie(text: 'this is test', number: testNumber);
    final loadedState =
        NumberTriviaLoadedState(numberTrivia: testNumberTriviaEntitie);
    test('should return [loading,loaded] states', (){
      when(randomNumberTriviaUseCase.getRandomNumberTrivia()).thenAnswer((realInvocation) async => Right(testNumberTriviaEntitie));

      //expectLater
      expectLater(triviaBloc.stream, emitsInOrder([NumberTriviaLoadingState(), NumberTriviaLoadedState(numberTrivia: testNumberTriviaEntitie)]));

      //act
      triviaBloc.add(RandomNumberTriviaGottenEvent());

    });

        test('should return [loading,Error] states', (){
      when(randomNumberTriviaUseCase.getRandomNumberTrivia()).thenAnswer((realInvocation) async => Left(ServerFailure(properties: [])));

      //expectLater
      expectLater(triviaBloc.stream, emitsInOrder([NumberTriviaLoadingState(), Error(message: 'Server Failure')]));

      //act
      triviaBloc.add(RandomNumberTriviaGottenEvent());

    });

  });
}
