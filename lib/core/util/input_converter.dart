import 'package:dartz/dartz.dart';
import 'package:tdd_number_trivia_app/core/error/failure.dart';

class InputConverter{
  static Either<Failure,int> convertStringToUnsignedInteger(String numberString){
    try{
      int number = int.parse(numberString);
      if(number < 0 ){
        throw FormatException('number should be 0 or above');
      }
      return Right(number);
    }on FormatException{
      return Left(FormatFailure());
    }
  }

}