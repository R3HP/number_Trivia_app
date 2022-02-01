import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_number_trivia_app/core/error/exception.dart';
import 'package:tdd_number_trivia_app/core/error/failure.dart';
import 'package:tdd_number_trivia_app/core/platform/remote_info.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/data/datasources/local_data_source.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/data/datasources/remote_data_source.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/data/models/trivia_model.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/data/repositories/number_trivia_repository_imp.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class MockNumberTriviaRepositoryImp extends Mock
    implements NumberTriviaRepository {}

class MockTriviaRemoteDataSource extends Mock
    implements TriviaRemoteDataSource {}

class MockTriviaLocalDataSource extends Mock implements TriviaLocalDataSource {}

class MockRemoteInfo extends Mock implements RemoteInfo {}

main() {
  // MockNumberTriviaRepositoryImp mockRepo ;
  late NumberTriviaRepositoryImplementation repository;
  late MockTriviaRemoteDataSource remoteDataSource;
  late MockTriviaLocalDataSource localDataSource;
  late MockRemoteInfo remoteInfo;
  final testNumber = 1;
  final NumberTriviaModel testNumberTriviaModel =
      NumberTriviaModel(text: 'this is test', number: testNumber);
  final NumberTriviaEntitie testNumberTriviaEntitie = testNumberTriviaModel;

  setUp(() {
    remoteDataSource = MockTriviaRemoteDataSource();
    localDataSource = MockTriviaLocalDataSource();
    remoteInfo = MockRemoteInfo();
    repository = NumberTriviaRepositoryImplementation(
        localDataSource: localDataSource,
        remoteDataSource: remoteDataSource,
        remoteInfo: remoteInfo);
  });

  
  group('concrete Number', () {
    group('device is online', () {
      setUp(() => when(remoteInfo.isConnected)
          .thenAnswer((realInvocation) async => true));
      test('should return a entity when remote call is succesful and cache it to local data source ', () async {
        //assign

        when(remoteDataSource.getConcreteNumberTrivia(testNumber))
            .thenAnswer((realInvocation) async => testNumberTriviaModel);
        //act
        final model = await repository.getConcreteNumberTrivia(testNumber);

        //assign
        verify(localDataSource.setTriviaToCahce(testNumberTriviaModel));
        expect(model, equals(Right(testNumberTriviaEntitie)));
      });

      test('should return a failure when remote call is unsuccesful', () async {
        //assign
        when(remoteDataSource.getConcreteNumberTrivia(testNumber))
        .thenThrow(ServerException());
        //act 
        final model = await repository.getConcreteNumberTrivia(testNumber);

        //assert
        expect(model, equals(Left(ServerFailure(properties: []))));
      });
    });
    group('device is offline', () { 
      setUp(() => 
      when(remoteInfo.isConnected).thenAnswer((realInvocation) async => false)
      );
      test('should return last entity from cache', () async{
        //assign
        when(localDataSource.getLastTriviaFromChache()).thenAnswer((realInvocation) async => testNumberTriviaModel);
        //act
        final model = await repository.getConcreteNumberTrivia(testNumber);
        //assert
        verifyZeroInteractions(remoteDataSource);
        expect(model, equals(Right(testNumberTriviaEntitie)));
      });

      test('should return a cahceFailure when local datasorce call is unsuccesful', () async{
        //assign 
        when(localDataSource.getLastTriviaFromChache()).thenThrow(CacheException());
        //act
        final model = await repository.getConcreteNumberTrivia(testNumber);
        //assert

        expect(model, equals(Left(CahceFailure(properties: []))));
      });
    });
  });
  group('Random Number', () {
    group('device is online', () {
      setUp(() => when(remoteInfo.isConnected)
          .thenAnswer((realInvocation) async => true));
      test('should return a entity when remote call is succesful and cache it to local data source ', () async {
        //assign

        when(remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((realInvocation) async => testNumberTriviaModel);
        //act
        final model = await repository.getRandomNumberTrivia();

        //assign
        verify(localDataSource.setTriviaToCahce(testNumberTriviaModel));
        expect(model, equals(Right(testNumberTriviaEntitie)));
      });

      test('should return a failure when remote call is unsuccesful', () async {
        //assign
        when(remoteDataSource.getRandomNumberTrivia())
        .thenThrow(ServerException());
        //act 
        final model = await repository.getRandomNumberTrivia();

        //assert
        expect(model, equals(Left(ServerFailure(properties: []))));
      });
    });

    group('device is offline', () {
      setUp(() => 
      when(remoteInfo.isConnected).thenAnswer((realInvocation) async => false)
      );
      test('should return last entity from cache', () async{
        //assign
        when(localDataSource.getLastTriviaFromChache()).thenAnswer((realInvocation) async => testNumberTriviaModel);
        //act
        final model = await repository.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(remoteDataSource);
        expect(model, equals(Right(testNumberTriviaEntitie)));
      });

      test('should return a cahceFailure when local datasorce call is unsuccesful', () async{
        //assign 
        when(localDataSource.getLastTriviaFromChache()).thenThrow(CacheException());
        //act
        final model = await repository.getRandomNumberTrivia();
        //assert

        expect(model, equals(Left(CahceFailure(properties: []))));
      });
    });
  });
}
