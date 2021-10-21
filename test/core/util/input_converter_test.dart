import 'package:dartz/dartz.dart';
import 'package:flutter_number_game/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToInt', () {
    test(
        'should return an integer when the string represents an integer',
        () async {
      const str = '111';
      final result = inputConverter.stringToInteger(str);
      expect(result, equals(const Right(111)));
    });

    test('should return a Failure when the string is not an integer', () async {
      const str = 'aaa';
      final result = inputConverter.stringToInteger(str);
      expect(result, equals(Left(InvalidInputFailure())));
    });

    test('should return a Failure when the string is a negative integer',
        () async {
      const str = '-111';
      final result = inputConverter.stringToInteger(str);
      expect(result, equals(Left(InvalidInputFailure())));
    });
  });
}
