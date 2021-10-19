import 'package:dartz/dartz.dart';
import 'package:flutter_number_game/core/error/failures.dart';
import 'package:flutter_number_game/domain/entities/number.dart';

abstract class NumberRepository{
  Future<Either<Failure, Number>>? getConcreteNumber(int number);
  Future<Either<Failure, Number>>? getRandomNumber();
}