import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_number_game/core/error/failures.dart';
import 'package:flutter_number_game/core/usecases/usecase.dart';
import 'package:flutter_number_game/core/util/input_converter.dart';
import 'package:flutter_number_game/domain/entities/number.dart';
import 'package:flutter_number_game/domain/usecases/get_concrete_number.dart';
import 'package:flutter_number_game/domain/usecases/get_random_number.dart';
import 'package:flutter_number_game/presentation/bloc/number_events.dart';
import 'package:flutter_number_game/presentation/bloc/number_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberBloc extends Bloc<NumberEvent, NumberState> {
  final GetConcreteNumber getConcreteNumber;
  final GetRandomNumber getRandomNumber;
  final InputConverter inputConverter;

  NumberBloc(
      {required this.getConcreteNumber,
      required this.getRandomNumber,
      required this.inputConverter})
      : super(Empty());

  get initialState => Empty();

  @override
  Stream<NumberState> mapEventToState(NumberEvent event) async* {
    if (event is GetConcreteNumberEvent) {
      final inputEither = inputConverter.stringToInteger(event.numberString);

      yield* inputEither.fold((failure) async* {
        yield const Error(msg: invalidInputFailureMessage);
      }, (integer) async* {
        yield Loading();

        final failureOrNumber =
            await getConcreteNumber(Params(number: integer));

        yield* _loadedOrErrorState(failureOrNumber!);
      });
    } else if (event is GetRandomNumberEvent) {
      yield Loading();
      final failureOrNumber = await getRandomNumber(NoParams());
      yield* _loadedOrErrorState(failureOrNumber!);
    }
  }

  Stream<NumberState> _loadedOrErrorState(
      Either<Failure, Number> failureOrNumber) async* {
    yield failureOrNumber.fold(
      (failure) => Error(msg: _failureToMsg(failure)),
      (number) => Loaded(number: number),
    );
  }

  String _failureToMsg(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected failure';
    }
  }
}
