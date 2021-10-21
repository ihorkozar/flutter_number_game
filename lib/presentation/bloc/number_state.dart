import 'package:equatable/equatable.dart';
import 'package:flutter_number_game/domain/entities/number.dart';

abstract class NumberState extends Equatable {
  const NumberState();

  @override
  List<Object> get props => [];
}

class Empty extends NumberState {}

class Loading extends NumberState {}

class Loaded extends NumberState {
  final Number number;

  const Loaded({required this.number});
}

class Error extends NumberState {
  final String msg;

  const Error({required this.msg});
}
