import 'dart:convert';
import 'package:flutter_number_game/core/error/exceptions.dart';
import 'package:flutter_number_game/data/models/number_model.dart';
import 'package:flutter_number_game/data/sources/local_datasoucre.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../fixture/fixture_reader.dart';
import 'local_datasource_test.mocks.dart';

@GenerateMocks([
  SharedPreferences
], customMocks: [
  MockSpec<SharedPreferences>(
      as: #MockSharedPreferencesForTest, returnNullOnMissingStub: true),
])
void main() {
  late NumberLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberLocalDataSourceImpl(sharedPref: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberModel.fromJson(json.decode(fixture('cached.json')));
    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      //arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('cached.json'));
      //act
      final result = await dataSource.getLastNumber();
      //assert
      verify(mockSharedPreferences.getString(cachedNumber));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a CacheException when there is not a cached value',
        () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //act
      final call = dataSource.getLastNumber;
      //assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberModel(number: 1, text: 'test trivia');
    test('should call SharedPreferences to cache the data', () async {
      //act
      dataSource.cacheNumber(tNumberTriviaModel);
      //assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(cachedNumber, expectedJsonString));
    });
  });
}
