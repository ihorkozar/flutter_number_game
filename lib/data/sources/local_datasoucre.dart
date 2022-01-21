import 'dart:convert';
import 'package:flutter_number_game/data/models/number_model.dart';
import '../../../../core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

const cachedNumber = 'CACHED_NUMBER';

abstract class NumberLocalDataSource {
  Future<NumberModel>? getLastNumber();

  Future<void>? cacheNumber(NumberModel toCache);
}

class NumberLocalDataSourceImpl implements NumberLocalDataSource {
  final SharedPreferences sharedPref;

  NumberLocalDataSourceImpl({required this.sharedPref});

  @override
  Future<NumberModel>? getLastNumber() {
    final jsonString = sharedPref.getString(cachedNumber);
    if (jsonString != null) {
      return Future.value(NumberModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }


  @override
  Future<void>? cacheNumber(NumberModel toCache) {
    return sharedPref.setString(
        cachedNumber, json.encode(toCache.toJson()),);
  }
}
