import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_number_game/core/error/exceptions.dart';
import 'package:flutter_number_game/data/models/number_model.dart';

const url = 'http://numbersapi.com';

//go to the retrofit in the feature

abstract class NumberRemoteDataSource {
  Future<NumberModel> getConcreteNumber(int number);
  Future<NumberModel> getRandomNumber();
}

class NumberRemoteDataSourceImpl implements NumberRemoteDataSource {
  final http.Client client;

  NumberRemoteDataSourceImpl({required this.client});

  Future<NumberModel> _getNumberFromUrl(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return NumberModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<NumberModel> getConcreteNumber(int number) =>
      _getNumberFromUrl('$url/$number');

  @override
  Future<NumberModel> getRandomNumber() => _getNumberFromUrl('$url/random');
}
