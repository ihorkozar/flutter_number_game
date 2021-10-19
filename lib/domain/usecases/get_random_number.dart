import 'package:dartz/dartz.dart';
import 'package:flutter_number_game/core/error/failures.dart';
import 'package:flutter_number_game/core/usecases/usecase.dart';
import 'package:flutter_number_game/domain/entities/number.dart';
import 'package:flutter_number_game/domain/repository/number_repository.dart';

class GetRandomNumber implements UseCase<Number, NoParams> {
  final NumberRepository repository;

  GetRandomNumber(this.repository);

  @override
  Future<Either<Failure, Number>?> call(NoParams params) async {
    return await repository.getRandomNumber();
  }
}