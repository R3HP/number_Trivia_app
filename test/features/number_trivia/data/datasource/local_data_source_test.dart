import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_number_trivia_app/core/error/exception.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/data/datasources/local_data_source.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/data/models/trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import './local_data_source_test.mocks.dart';


@GenerateMocks([SharedPreferences])
main() {
  late TriviaLocalDataSourceImp dataSourceImp;
  late MockSharedPreferences mockSharedPreferences;
  setUp((){
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImp = TriviaLocalDataSourceImp(sharedPreference: mockSharedPreferences);
  });

  group('LocalDataSource', () {

    group('get last trivia from cache', (){
      late NumberTriviaModel model;
      setUp((){
        model = NumberTriviaModel(number: 1, text: 'this is test');
      });
      test('should invoke SharedPreference.getString and return a Future<NumberTriviaModel', ()async{
        //assign
        when(mockSharedPreferences.getString(Number_Trivia_Cache_Key)).thenReturn(readFixture('trivia.json'));

        // act
        final result = await dataSourceImp.getLastTriviaFromChache();

        //assert
        verify(mockSharedPreferences.getString(Number_Trivia_Cache_Key));
        expect(result, equals(model));

      });

      test('should return a Cache Exception when there is nothing in cache', ()async{
        //assign
        when(mockSharedPreferences.getString(Number_Trivia_Cache_Key)).thenReturn(null);

        //act 
        final result =  dataSourceImp.getLastTriviaFromChache;
        // becuase function throws a error we should check if calling the function thorwA(TypeMatcher<>())
        // unlike repository which returns an either , 
        //in there we could check if the result was the left side of either whic was a failure


        //assert
        expect(() =>result(), throwsA(TypeMatcher<CacheException>()));

      });

      test('should return a Cache Exception when calling shared preference thows an exception aka stored cache is not a string', (){
        //assign
        when(mockSharedPreferences.getString(Number_Trivia_Cache_Key)).thenThrow(Exception());
        //act
        final result = dataSourceImp.getLastTriviaFromChache;

        //assert
        expect(() => result(), throwsA(TypeMatcher<CacheException>()));
      });
    });
    
    group('write to cache', (){
      late NumberTriviaModel model;
      late String triviaString;
      setUp((){
        model = NumberTriviaModel(number: 1, text: 'this is test');
        triviaString = json.encode(model.toMap());
      });
      test('should save the model in cache', ()async{
        //assign
        when(mockSharedPreferences.setString(Number_Trivia_Cache_Key,triviaString)).thenAnswer((realInvocation)async => true);
        // act 
        dataSourceImp.setTriviaToCahce(model);
        // assert
        verify(mockSharedPreferences.setString(Number_Trivia_Cache_Key, triviaString));
      });
    });
  });
  
}