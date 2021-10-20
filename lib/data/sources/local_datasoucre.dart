import 'dart:convert';
import 'package:flutter_number_game/data/models/number_model.dart';
import 'package:flutter_number_game/domain/entities/number.dart';
import '../../../../core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

const cachedNumber = 'CACHED_NUMBER';

abstract class NumberLocalDataSource {
  Future<NumberModel>? getLastNumber();

  Future<void>? cacheNumber(Number toCache);
}

// class NumberLocalDataSourceImpl implements NumberLocalDataSource {
//   final SharedPreferences sharedPreferences;
//
//   NumberLocalDataSourceImpl({required this.sharedPreferences});
//
//   @override
//   Future<NumberModel>? getLastNumber() {
//     final jsonString = sharedPreferences.getString(cachedNumber);
//     if (jsonString != null) {
//       return Future.value(NumberModel.fromJson(json.decode(jsonString)));
//     } else {
//       throw CacheException();
//     }
//   }
//
//   @override
//   Future<void>? cacheNumber(Number toCache) {
//     // TODO: implement cacheNumber
//     throw UnimplementedError();
//   }
//
//   // @override
//   // Future<void>? cacheNumber(Number toCache) {
//   //   return sharedPreferences.setString(
//   //       cachedNumber, json.encode(toCache.toJson()));
//   // }
// }
