import 'package:equatable/equatable.dart';

class Number extends Equatable{
  final String text;
  final int number;

  Number({required this.text, required this.number});

  @override
  List<Object?> get props => throw UnimplementedError();

}