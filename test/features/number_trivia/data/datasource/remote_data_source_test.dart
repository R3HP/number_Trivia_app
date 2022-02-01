import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:tdd_number_trivia_app/core/error/exception.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/data/datasources/remote_data_source.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/data/models/trivia_model.dart';


import '../../../../fixtures/fixture_reader.dart';
import './remote_data_source_test.mocks.dart';
@GenerateMocks([http.Client])
main() {
  late final MockClient mockHttpClient = MockClient();
  late final TriviaRemoteDataSourceImp dataSource = TriviaRemoteDataSourceImp(client: mockHttpClient);
  final testNumber = 1;
  final testModel = NumberTriviaModel(number: testNumber, text: 'this is test');
  final testSuccesResponse = http.Response(readFixture('trivia.json'),200);
  final testFailResponse = http.Response('there is a problem with server', 404);
  // setUp((){
  //   mockHttpClient = MockClient();
  //   dataSource = TriviaRemoteDataSourceImp(client: mockHttpClient);
  // });

  group('get Concrete Trivia', (){

    test('should get trivia from remote api', () async {
      //assign   
      Uri url = Uri.parse(baseUrl+testNumber.toString());
      when(mockHttpClient.get(url,headers: {'Content-Type' : 'application/json'})).thenAnswer((_)  async => 
      testSuccesResponse
      );
      //act 
      final response =await dataSource.getConcreteNumberTrivia(testNumber);
      //assert 
      verify(mockHttpClient.get(url,headers: {'Content-Type' : 'application/json'}));
      expect(response, equals(testModel));
    });
    test('should throw a ServerException when the status code is not 200', (){
      //assign   
      Uri url = Uri.parse(baseUrl+testNumber.toString());
      when(mockHttpClient.get(url,headers: {'Content-Type' : 'application/json'})).thenAnswer((_)  async => 
      testFailResponse
      );
      // act 
      final call = dataSource.getConcreteNumberTrivia;
      // assert that calling the function above would throw a exception
      expect(() => call(testNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('get Random Trivia', (){
    test('should return a random trivia from numbersapi,com/random', () async {
      //assign
      Uri url = Uri.parse(baseUrl+'random');
      when(mockHttpClient.get(any,headers: anyNamed('headers'))).thenAnswer((realInvocation) async => testSuccesResponse);
      //act
      final response = await dataSource.getRandomNumberTrivia();
      //assert
      verify(mockHttpClient.get(url,headers: {'Content-Type' : 'application/json'}));
      expect(response,equals(testModel));
    });

    test('should thorw a ServerException when trying to call numberapi.com/random', (){
      //assign
      Uri url = Uri.parse(baseUrl+'random');
      when(mockHttpClient.get(any,headers: anyNamed('headers'))).thenAnswer((realInvocation) async => testFailResponse);
      //act
      final call = dataSource.getRandomNumberTrivia;
      //assert
      expect(() => call(), throwsA(TypeMatcher<ServerException>()));

    });
  });
}
