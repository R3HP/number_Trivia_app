
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_number_trivia_app/core/error/failure.dart';
import 'package:tdd_number_trivia_app/core/util/input_converter.dart';

main() {
  

  test('should return an int for 122', (){
    // assign
    final numberString = '122';
    // act
    final number = InputConverter.convertStringToUnsignedInteger(numberString);
    //assert
    expect(number, Right(122));
  });

  test('should return a FormatFailure for s12', (){
    // assign
    final numberString = 's12';
    // act
    final number = InputConverter.convertStringToUnsignedInteger(numberString);
    //assert
    expect(number, Left(FormatFailure()));
  });

  test('should return FormatFailure fro -122', (){
    //assign
    final numberString ='-122';
    //act
    final number = InputConverter.convertStringToUnsignedInteger(numberString);
    //assert
    expect(number, Left(FormatFailure()));
  });
  
}