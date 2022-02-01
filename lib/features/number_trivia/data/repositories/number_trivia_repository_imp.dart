import 'package:tdd_number_trivia_app/core/error/exception.dart';
import 'package:tdd_number_trivia_app/core/platform/remote_info.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/data/datasources/local_data_source.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/data/datasources/remote_data_source.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/data/models/trivia_model.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_number_trivia_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef Future<NumberTriviaModel>? _ConcreateOrRandomChooser();

class NumberTriviaRepositoryImplementation implements NumberTriviaRepository {
  final TriviaLocalDataSource localDataSource;
  final TriviaRemoteDataSource remoteDataSource;
  final RemoteInfo remoteInfo;

  NumberTriviaRepositoryImplementation(
      {required this.localDataSource,
      required this.remoteDataSource,
      required this.remoteInfo});

  @override
  Future<Either<Failure, NumberTriviaEntitie>>? getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    })!;
  }

  @override
  Future<Either<Failure, NumberTriviaEntitie>>? getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    })!;
  }

  Future<Either<Failure, NumberTriviaEntitie>>? _getTrivia(
      _ConcreateOrRandomChooser getConcreteOrRandom) async {
    if (await remoteInfo.isConnected!) {
      try {
        final model = await getConcreteOrRandom();
        localDataSource.setTriviaToCahce(model!);
        return Right(model);
      } on ServerException {
        return Left(ServerFailure(properties: []));
      }
    } else {
      try {
        final model = await localDataSource.getLastTriviaFromChache();
        return Right(model!);
      } on CacheException {
        return Left(CahceFailure(properties: []));
      }
    }
  }
}
