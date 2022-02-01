import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  final List properties ;
  @override
  // TODO: implement props
  List<Object?> get props => properties;
  const Failure({required this.properties}) :super();
  
}

class FormatFailure extends Failure{
  const FormatFailure() : super(properties: const []);
}



class ServerFailure extends Failure{
  const ServerFailure({required properties}) : super(properties: properties);
}

class CahceFailure extends Failure{
  const CahceFailure({required properties}) : super(properties: properties);
}