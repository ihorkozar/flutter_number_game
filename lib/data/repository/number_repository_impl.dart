import 'package:dartz/dartz.dart';
import 'package:flutter_number_game/core/error/failures.dart';
import 'package:flutter_number_game/core/platform/network_info.dart';
import 'package:flutter_number_game/data/sources/local_datasoucre.dart';
import 'package:flutter_number_game/data/sources/remote_datasource.dart';
import 'package:flutter_number_game/domain/entities/number.dart';
import 'package:flutter_number_game/domain/repository/number_repository.dart';

class NumberRepositoryImpl implements NumberRepository {
  NumberRemoteDataSource remoteDataSource;
  NumberLocalDataSource localDataSource;
  NetworkInfo networkInfo;

  NumberRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, Number>>? getConcreteNumber(int number) {}

  @override
  Future<Either<Failure, Number>>? getRandomNumber() {}
}
