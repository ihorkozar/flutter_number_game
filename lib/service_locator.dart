import 'package:flutter_number_game/core/platform/network_info.dart';
import 'package:flutter_number_game/core/util/input_converter.dart';
import 'package:flutter_number_game/data/repository/number_repository_impl.dart';
import 'package:flutter_number_game/data/sources/local_datasoucre.dart';
import 'package:flutter_number_game/data/sources/remote_datasource.dart';
import 'package:flutter_number_game/domain/repository/number_repository.dart';
import 'package:flutter_number_game/domain/usecases/get_concrete_number.dart';
import 'package:flutter_number_game/domain/usecases/get_random_number.dart';
import 'package:flutter_number_game/presentation/bloc/number_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //Bloc
  serviceLocator.registerFactory(() => NumberBloc(
      getConcreteNumber: serviceLocator(),
      getRandomNumber: serviceLocator(),
      inputConverter: serviceLocator(),));

  //Use cases
  serviceLocator
      .registerLazySingleton(() => GetConcreteNumber(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetRandomNumber(serviceLocator()));

  //Repository
  serviceLocator.registerLazySingleton<NumberRepository>(() =>
      NumberRepositoryImpl(
          remoteDataSource: serviceLocator(),
          localDataSource: serviceLocator(),
          networkInfo: serviceLocator(),));

  // Data sources
  serviceLocator.registerLazySingleton<NumberLocalDataSource>(
      () => NumberLocalDataSourceImpl(sharedPref: serviceLocator()),);
  serviceLocator.registerLazySingleton<NumberRemoteDataSource>(
      () => NumberRemoteDataSourceImpl(client: serviceLocator()),);

  //InputConverter
  serviceLocator.registerLazySingleton(() => InputConverter());

  //NetworkInfo
  serviceLocator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(serviceLocator()),);

  //SharedPref
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);

  //HttpClient
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => InternetConnectionChecker());
}
