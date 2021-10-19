import 'package:flutter_number_game/core/platform/network_info.dart';
import 'package:flutter_number_game/data/repository/number_repository_impl.dart';
import 'package:flutter_number_game/data/sources/local_datasoucre.dart';
import 'package:flutter_number_game/data/sources/remote_datasource.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock implements NumberRemoteDataSource{}

class MockLocalDataSource extends Mock implements NumberLocalDataSource{}

class MockNetworkInfo extends Mock implements NetworkInfo{}

void main(){
  late NumberRepositoryImpl repositoryImpl;
  late MockRemoteDataSource remoteDataSource;
  late MockLocalDataSource localDataSource;
  late MockNetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    localDataSource = MockLocalDataSource();
    networkInfo = MockNetworkInfo();
    repositoryImpl = NumberRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

}