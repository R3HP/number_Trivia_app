

import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_number_trivia_app/core/platform/remote_info.dart';


import './remote_info_test.mocks.dart';

// class MockInternetConncetionChecker extends Mock implements InternetConnectionChecker{
// }
@GenerateMocks([InternetConnectionChecker])
main() {
  late RemoteInfoImp remoteInfoImp ;
  late MockInternetConnectionChecker mockDataConncetionChecker;
  final testConnectionAnswer = Future.value(true);

  setUp((){
    mockDataConncetionChecker = MockInternetConnectionChecker();
    remoteInfoImp= RemoteInfoImp(mockDataConncetionChecker);
  });

  test('should check connection', (){
    //assign 
    when(mockDataConncetionChecker.hasConnection).thenAnswer((realInvocation)  => testConnectionAnswer);

    // act
    final isConnected = remoteInfoImp.isConnected;

    // assert
    expect(isConnected, testConnectionAnswer);
    // verify(mockDataConncetionChecker.hasConnection);
  });
  
}