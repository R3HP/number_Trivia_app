

import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class RemoteInfo{
  Future<bool>? get isConnected;
}

class RemoteInfoImp extends RemoteInfo{
  final InternetConnectionChecker checker ;
  RemoteInfoImp(this.checker);
  @override
  // TODO: implement isConnected
  Future<bool>? get isConnected {
    return checker.hasConnection;
  }
}