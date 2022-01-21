import 'package:dartz/dartz.dart';
import 'package:flutter_number_game/core/error/exceptions.dart';
import 'package:flutter_number_game/core/error/failures.dart';
import 'package:flutter_number_game/core/platform/network_info.dart';
import 'package:flutter_number_game/data/models/number_model.dart';
import 'package:flutter_number_game/data/sources/local_datasoucre.dart';
import 'package:flutter_number_game/data/sources/remote_datasource.dart';
import 'package:flutter_number_game/domain/entities/number.dart';
import 'package:flutter_number_game/domain/repository/number_repository.dart';

typedef _ConcreteOrRandomChooser = Future<NumberModel> Function();

class NumberRepositoryImpl implements NumberRepository {
  NumberRemoteDataSource remoteDataSource;
  NumberLocalDataSource localDataSource;
  NetworkInfo networkInfo;

  NumberRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo,});

  @override
  Future<Either<Failure, Number>>? getConcreteNumber(
      int number,) async {
    return await _getNumber(() {
      return remoteDataSource.getConcreteNumber(number);
    });
  }

  @override
  Future<Either<Failure, Number>> getRandomNumber() async {
    return await _getNumber(() {
      return remoteDataSource.getRandomNumber();
    });
  }

  Future<Either<Failure, Number>> _getNumber(
      _ConcreteOrRandomChooser getConcreteOrRandom,) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteNumber = await getConcreteOrRandom();
        localDataSource.cacheNumber(remoteNumber);
        return Right(remoteNumber);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localNumber = await localDataSource.getLastNumber();
        return Right(localNumber!);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
