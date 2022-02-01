import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/domain/usecases/get_concret_number_trivia.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository{}



main() {
  MockNumberTriviaRepository? mockNumberTriviaRepository ;
  GetConcretNumberTrivia? getConcretNumberTriviaUseCase ;
  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    getConcretNumberTriviaUseCase = GetConcretNumberTrivia(repository: mockNumberTriviaRepository!);
  });

  int testNumber = 7;
  NumberTriviaEntitie testNumberTrivia = NumberTriviaEntitie(text: 'this is number 7', number: testNumber);

  test('should get trivia from repository', () async {
    //arrange
    when(mockNumberTriviaRepository!.getConcreteNumberTrivia(testNumber))
    .thenAnswer((_) async {
      return Right(testNumberTrivia);
    });
    //act
    final answer = await getConcretNumberTriviaUseCase!.exec(testNumber);
    //assert
    expect(answer, Right(testNumberTrivia));
    verify(mockNumberTriviaRepository!.getConcreteNumberTrivia(testNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  }
  );
}