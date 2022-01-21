import 'dart:convert';
import 'package:flutter_number_game/core/error/exceptions.dart';
import 'package:flutter_number_game/data/models/number_model.dart';
import 'package:flutter_number_game/data/sources/remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../fixture/fixture_reader.dart';
import 'remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = NumberRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('test.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberModel =
        NumberModel.fromJson(json.decode(fixture('test.json')));

    test('''should perform a get request on a URL with number
    being the endpoint and with application/json header''', () async {
      setUpMockHttpClientSuccess200();
      dataSource.getConcreteNumber(tNumber);
      verify(mockHttpClient.get(Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSource.getConcreteNumber(tNumber);
      //assert
      expect(result, equals(tNumberModel));
    });
    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final call = dataSource.getConcreteNumber;
      //assert
      expect(() => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });
  group('getRandomNumberTrivia', () {
    final tNumberModel =
        NumberModel.fromJson(json.decode(fixture('test.json')));
    test('should perform a get request on a URL with random endpoint ',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      dataSource.getRandomNumber();
      //assert
      verify(mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSource.getRandomNumber();
      //assert
      expect(result, equals(tNumberModel));
    });
    test(
        'should throw a ServerException when the response code is 404',
        () async {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final call = dataSource.getRandomNumber;
      //assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
