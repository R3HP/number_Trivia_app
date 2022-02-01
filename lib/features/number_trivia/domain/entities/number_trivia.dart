
import 'package:equatable/equatable.dart';

class NumberTriviaEntitie extends Equatable{
  final String text;
  final int number;

  const NumberTriviaEntitie({required this.text, required this.number} ): super();
  @override
  // TODO: implement props
  List<Object?> get props => [text,number];

}