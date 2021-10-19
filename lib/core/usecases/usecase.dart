import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_number_game/core/error/failures.dart';
import 'package:flutter_number_game/domain/entities/number.dart';

abstract class UseCase<Type, Params>{
  Future<Either<Failure, Number>?> call(Params params);
}

class NoParams extends Equatable{
  @override
  List<Object?> get props => [];
}