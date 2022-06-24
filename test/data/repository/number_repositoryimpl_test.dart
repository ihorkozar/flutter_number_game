import 'package:dartz/dartz.dart';
import 'package:flutter_number_game/core/error/exceptions.dart';
import 'package:flutter_number_game/core/error/failures.dart';
import 'package:flutter_number_game/core/platform/network_info.dart';
import 'package:flutter_number_game/data/models/number_model.dart';
import 'package:flutter_number_game/data/repository/number_repository_impl.dart';
import 'package:flutter_number_game/data/sources/local_datasoucre.dart';
import 'package:flutter_number_game/data/sources/remote_datasource.dart';
import 'package:flutter_number_game/domain/entities/number.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'number_repositoryimpl_test.mocks.dart';

class MockNumberLocalDataSource extends Mock implements NumberLocalDataSource {}

@GenerateMocks([NetworkInfo])
@GenerateMocks([NumberRemoteDataSource])
void main() {
  late NumberRepositoryImpl repositoryImpl;
  late MockNumberRemoteDataSource remoteDataSource;
  late MockNumberLocalDataSource localDataSource;
  late MockNetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = MockNumberRemoteDataSource();
    localDataSource = MockNumberLocalDataSource();
    networkInfo = MockNetworkInfo();
    repositoryImpl = NumberRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumber', () {
    const tNumber = 1;
    const tNumberModel = NumberModel(text: 'test', number: tNumber);
    const Number tNumberInfo = tNumberModel;

    test('the device is online', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      //repositoryImpl.getConcreteNumber(tNumber);
      expect(await networkInfo.isConnected, true);
    });

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          //arrange
          when(remoteDataSource.getConcreteNumber(tNumber))
              .thenAnswer((_) async => tNumberModel);
          //act
          final result = await repositoryImpl.getConcreteNumber(tNumber);
          //assert
          verify(remoteDataSource.getConcreteNumber(tNumber));
          expect(result, equals(const Right(tNumberInfo)));
        },
      );
      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          //arrange
          when(remoteDataSource.getConcreteNumber(tNumber))
              .thenAnswer((_) async => tNumberModel);
          //act
          await repositoryImpl.getConcreteNumber(tNumber);
          //assert
          verify(remoteDataSource.getConcreteNumber(tNumber));
          verify(localDataSource.cacheNumber(tNumberModel));
        },
      );
      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          //arrange
          when(remoteDataSource.getConcreteNumber(tNumber))
              .thenThrow(ServerException());
          //act
          final result = await repositoryImpl.getConcreteNumber(tNumber);
          //assert
          verify(remoteDataSource.getConcreteNumber(tNumber));
          verifyZeroInteractions(localDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          //arrange
          when(localDataSource.getLastNumber())
              .thenAnswer((_) async => tNumberModel);
          //act
          final result = await repositoryImpl.getConcreteNumber(tNumber);
          //assert
          verifyZeroInteractions(remoteDataSource);
          verify(localDataSource.getLastNumber());
          expect(result, equals(const Right(tNumberInfo)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          //arrange
          when(localDataSource.getLastNumber()).thenThrow(CacheException());
          //act
          final result = await repositoryImpl.getConcreteNumber(tNumber);
          //assert
          verifyZeroInteractions(remoteDataSource);
          verify(localDataSource.getLastNumber());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getRandomNumber', () {
    const tNumberModel = NumberModel(text: 'test', number: 1);
    const Number tNumberInfo = tNumberModel;

    // test('should check if the device is online', () async {
    //   when(networkInfo.isConnected).thenAnswer((_) async => true);
    //   repositoryImpl.getRandomNumber();
    //   verify(networkInfo.isConnected);
    // });

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          when(remoteDataSource.getRandomNumber())
              .thenAnswer((_) async => tNumberModel);

          final result = await repositoryImpl.getRandomNumber();

          verify(remoteDataSource.getRandomNumber());
          expect(result, equals(const Right(tNumberInfo)));
        },
      );
      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          when(remoteDataSource.getRandomNumber())
              .thenAnswer((_) async => tNumberModel);

          await repositoryImpl.getRandomNumber();

          verify(remoteDataSource.getRandomNumber());
          verify(localDataSource.cacheNumber(tNumberModel));
        },
      );
      test(
        'should return serverfailure when the call to remote data source is successful',
        () async {
          when(remoteDataSource.getRandomNumber()).thenThrow(ServerException());

          final result = await repositoryImpl.getRandomNumber();

          verify(remoteDataSource.getRandomNumber());
          verifyZeroInteractions(localDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          when(localDataSource.getLastNumber())
              .thenAnswer((_) async => tNumberModel);

          final result = await repositoryImpl.getRandomNumber();

          verifyZeroInteractions(remoteDataSource);
          verify(localDataSource.getLastNumber());
          expect(result, equals(const Right(tNumberInfo)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          when(localDataSource.getLastNumber()).thenThrow(CacheException());

          final result = await repositoryImpl.getRandomNumber();

          verifyZeroInteractions(remoteDataSource);
          verify(localDataSource.getLastNumber());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
