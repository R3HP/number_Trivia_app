import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_number_trivia_app/core/error/exception.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/data/models/trivia_model.dart';

const Number_Trivia_Cache_Key = 'NumberTriviaCacheKey';

abstract class TriviaLocalDataSource {
  Future<NumberTriviaModel>? getLastTriviaFromChache();

  Future<void>? setTriviaToCahce(NumberTriviaModel numberTriviaModel);
}

class TriviaLocalDataSourceImp implements TriviaLocalDataSource {
  final SharedPreferences sharedPreference;

  TriviaLocalDataSourceImp({required this.sharedPreference});

  @override
  Future<NumberTriviaModel>? getLastTriviaFromChache() {
    try {
      final trivaString = sharedPreference.getString(Number_Trivia_Cache_Key);
      if (trivaString != null) {
        return Future.value(
            NumberTriviaModel.fromMap(json.decode(trivaString)));
      } else {
        throw CacheException();
      }
    } catch (err) {
      throw CacheException();
    }
  }

  @override
  Future<void>? setTriviaToCahce(NumberTriviaModel numberTriviaModel) async{
    final triviaString = json.encode(numberTriviaModel.toMap());
    final res = await sharedPreference.setString(Number_Trivia_Cache_Key, triviaString);
    if(res){
      return ;
    }else{
      throw CacheException();
    }
  }
}
