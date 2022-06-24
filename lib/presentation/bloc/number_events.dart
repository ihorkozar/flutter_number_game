import 'package:equatable/equatable.dart';

abstract class NumberEvent extends Equatable {
  const NumberEvent();

  @override
  List<Object> get props => [];
}

class GetConcreteNumberEvent extends NumberEvent {
  final String numberString;

  const GetConcreteNumberEvent(this.numberString);
}

class GetRandomNumberEvent extends NumberEvent {}
