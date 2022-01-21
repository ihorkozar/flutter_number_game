import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_number_game/core/error/failures.dart';
import 'package:flutter_number_game/core/usecases/usecase.dart';
import 'package:flutter_number_game/domain/entities/number.dart';
import 'package:flutter_number_game/domain/repository/number_repository.dart';

class GetConcreteNumber implements UseCase<Number, Params> {
  final NumberRepository repository;

  GetConcreteNumber(this.repository);

  @override
  Future<Either<Failure, Number>?> call(Params params) async {
    return await repository.getConcreteNumber(params.number);
  }
}

class Params extends Equatable{
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
