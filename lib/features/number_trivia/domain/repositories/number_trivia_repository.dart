
import 'package:dartz/dartz.dart';
import 'package:tdd_number_trivia_app/core/error/failure.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure,NumberTriviaEntitie>>? getConcreteNumberTrivia(int number);
  Future<Either<Failure,NumberTriviaEntitie>>? getRandomNumberTrivia();
}