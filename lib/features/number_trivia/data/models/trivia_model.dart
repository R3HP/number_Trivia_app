import 'package:tdd_number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTriviaEntitie{
  NumberTriviaModel(
    {required int number,required String text}
  ) : super(number: number,text: text);


  factory NumberTriviaModel.fromMap(Map<String,dynamic> jsonMap){
    return NumberTriviaModel(number: (jsonMap['number'] as num).toInt(), text: jsonMap['text']);
  }

  Map<String,dynamic> toMap(){
    return {
      'number' : number,
      'text' : text
    };
  }

  
}