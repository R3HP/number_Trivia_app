
import 'package:dartz/dartz.dart';
import 'package:tdd_number_trivia_app/core/error/failure.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcretNumberTrivia {
  final NumberTriviaRepository repository;

  GetConcretNumberTrivia({required this.repository});


  Future<Either<Failure,NumberTriviaEntitie>?> exec(int number) async {
    return await repository.getConcreteNumberTrivia(number);
  }

}