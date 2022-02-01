
import 'dart:convert';

import 'package:tdd_number_trivia_app/core/error/exception.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/data/models/trivia_model.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://numberapi.com/';

typedef Future<NumberTriviaModel>? getConcreteOrRandom();

abstract class TriviaRemoteDataSource {
  late Uri url;
  Future<NumberTriviaModel>? getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel>? getRandomNumberTrivia();
}

class TriviaRemoteDataSourceImp extends TriviaRemoteDataSource{
  final http.Client client;
  TriviaRemoteDataSourceImp({required this.client});
  @override
  Future<NumberTriviaModel>? getConcreteNumberTrivia(int number) async {
    url = Uri.parse(baseUrl+number.toString());
    return await getTrivia();
  }

  @override
  Future<NumberTriviaModel>? getRandomNumberTrivia() async {
    url = Uri.parse(baseUrl+'random');
    return await getTrivia();
    
  }

  Future<NumberTriviaModel> getTrivia() async {
    try{
    final response = await client.get(url,headers: {'Content-Type' : 'application/json'});
    if(response.statusCode == 200){
    return NumberTriviaModel.fromMap(json.decode(response.body));
    }else{
      throw ServerException();
    }
    } catch (err){
      throw ServerException();
    }
  }
}