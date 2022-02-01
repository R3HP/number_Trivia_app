import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/data/models/trivia_model.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

main() {
  final testNumberTriviaModel =
      NumberTriviaModel(text: 'this is test', number: 1);

  group('trivia model tests', () {
    test('is a number trivia entitie', () {
      //assert
      expect(testNumberTriviaModel, isA<NumberTriviaEntitie>());
    });

    test('should read fromJson String integer', () {
      //assing
      final fixtureString = readFixture('trivia.json');
      final jsonMap = json.decode(fixtureString);

      //act
      final triviaModel = NumberTriviaModel.fromMap(jsonMap);

      //assert
      expect(triviaModel, testNumberTriviaModel);
    });

    test('should read fromJson String while number is regarded in double', () {
      //assing
      final fixtureString = readFixture('trivia_double.json');
      final jsonMap = json.decode(fixtureString);

      //act
      final triviaModel = NumberTriviaModel.fromMap(jsonMap);

      //assert
      expect(triviaModel, testNumberTriviaModel);
    });

    test('should make a json out of model', () {
      //assing
      final expectedMap = {
        'number' : 1,
        'text' : 'this is test'
      };
      // act
      final triviaMap = testNumberTriviaModel.toMap();

      // assert
      expect(triviaMap,expectedMap);
    });
  });
}
