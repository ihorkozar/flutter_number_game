import 'package:dartz/dartz.dart';
import 'package:flutter_number_game/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToInteger(String string) {
    try {
      final intNum = int.parse(string);
      if (intNum < 0) throw const FormatException();
      return Right(intNum);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}
