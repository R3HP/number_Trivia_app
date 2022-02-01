import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_number_trivia_app/core/platform/remote_info.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/data/datasources/local_data_source.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/data/datasources/remote_data_source.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/data/repositories/number_trivia_repository_imp.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/domain/usecases/get_concret_number_trivia.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:tdd_number_trivia_app/features/number_trivia/presentation/bloc/numbertriva_bloc.dart';
import 'package:http/http.dart' as http;

final getIt = GetIt.instance;

Future<void> initDependecy() async {
  //features
  // features - numberTrivia

  //BLoC
  getIt.registerFactory(
      () => NumberTriviaBloc(concrete: getIt(), random: getIt()));

  //UseCases

  getIt
      .registerLazySingleton(() => GetConcretNumberTrivia(repository: getIt()));
  getIt.registerLazySingleton(() => GetRandomNumberTrivia(repository: getIt()));

  //Repositories

  getIt.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImplementation(
          localDataSource: getIt(),
          remoteDataSource: getIt(),
          remoteInfo: getIt()));

  getIt.registerLazySingleton<TriviaLocalDataSource>(() => TriviaLocalDataSourceImp(sharedPreference: getIt()));

  getIt.registerLazySingleton<TriviaRemoteDataSource>(() => TriviaRemoteDataSourceImp(client: getIt()));

  //core

  //RemoteInfo

  getIt.registerLazySingleton<RemoteInfo>(() => RemoteInfoImp(getIt()));

  //export

  //InternetConnectionChecker
  getIt.registerLazySingleton(() => InternetConnectionChecker());

  //httpClient
  getIt.registerLazySingleton(() => http.Client());

  //sharedPreference
  final shared = await SharedPreferences.getInstance();
  // getIt.registerLazySingletonAsync(() async=> await SharedPreferences.getInstance());
  getIt.registerLazySingleton(() => shared);
}
