import 'dart:convert';
import 'package:flutter_number_game/data/models/number_model.dart';
import 'package:flutter_number_game/domain/entities/number.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../fixture/fixture_reader.dart';

void main() {
  const tNumberModel = NumberModel(number: 1, text: 'test text');

  test('is it subclass of Number', () async {
    expect(tNumberModel, isA<Number>());
  });

  group('fromJson', () {
    test('return model when JSON number is int', () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('test.json'));
      final res = NumberModel.fromJson(jsonMap);
      expect(res, tNumberModel);
    });

    test('return model when JSON number is double', () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('test_double.json'));
      final res = NumberModel.fromJson(jsonMap);
      expect(res, tNumberModel);
    });
  });

  group('toJson', () {
    test('return a JSON containing the data', () async {
      final map = {
        "text": "test text",
        "number": 1,
      };
      final res = tNumberModel.toJson();
      expect(res, map);
    });
  });
}
