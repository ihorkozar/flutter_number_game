import 'package:dartz/dartz.dart';
import 'package:flutter_number_game/core/error/failures.dart';
import 'package:flutter_number_game/core/usecases/usecase.dart';
import 'package:flutter_number_game/core/util/input_converter.dart';
import 'package:flutter_number_game/domain/entities/number.dart';
import 'package:flutter_number_game/domain/usecases/get_concrete_number.dart';
import 'package:flutter_number_game/domain/usecases/get_random_number.dart';
import 'package:flutter_number_game/presentation/bloc/number_bloc.dart';
import 'package:flutter_number_game/presentation/bloc/number_events.dart';
import 'package:flutter_number_game/presentation/bloc/number_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'number_bloc_test.mocks.dart';

const String serverFailureMsg = 'Server Failure';
const String cacheFailureMsg = 'Cache Failure';
const String invalidInputFailureMsg =
    'Invalid Input - The number must be a positive integer or zero.';

@GenerateMocks([GetConcreteNumber])
@GenerateMocks([GetRandomNumber])
@GenerateMocks([InputConverter])
void main() {
  late NumberBloc bloc;
  late MockGetConcreteNumber mockGetConcreteNumber;
  late MockGetRandomNumber mockGetRandomNumber;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockInputConverter = MockInputConverter();
    mockGetRandomNumber = MockGetRandomNumber();
    mockGetConcreteNumber = MockGetConcreteNumber();
    bloc = NumberBloc(
        getConcreteNumber: mockGetConcreteNumber,
        getRandomNumber: mockGetRandomNumber,
        inputConverter: mockInputConverter);
  });

  test('initialState should be Empty', () async {
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberInfo = Number(text: 'test', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToInteger(any))
            .thenReturn(const Right(tNumberParsed));

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async* {
      setUpMockInputConverterSuccess();
      bloc.add(const GetConcreteNumberEvent(tNumberString));
      await untilCalled(mockInputConverter.stringToInteger(any));
      verify(mockInputConverter.stringToInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid.', () async* {
      when(mockInputConverter.stringToInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      final expected = [
        Empty(),
        const Error(msg: invalidInputFailureMsg),
      ]; //bloc always emit first state

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(const GetConcreteNumberEvent(tNumberString));
    });

    test('should get data from the concrete usecase', () async* {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumber(any))
          .thenAnswer((_) async => const Right(tNumberInfo));
      bloc.add(const GetConcreteNumberEvent(tNumberString));
      await untilCalled(mockGetRandomNumber(any));
      verify(mockGetConcreteNumber(const Params(number: tNumberParsed)));
    });

    test('should emits [Loading, Loaded] when data is gotten successfully',
        () async* {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumber(any))
          .thenAnswer((_) async => const Right(tNumberInfo));
      final expeted = [Empty(), Loading(), const Loaded(number: tNumberInfo)];
      expectLater(bloc, emitsInOrder(expeted));
      bloc.add(const GetConcreteNumberEvent(tNumberString));
    });

    test('should emits [Loading, Error] when getting data fails', () async* {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumber(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      final expected = [Empty(), Loading(), const Error(msg: serverFailureMsg)];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(const GetConcreteNumberEvent(tNumberString));
    });

    test(
        'should emits [Loading, Error] with a proper message for the error when getting data fails',
        () async* {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumber(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [Empty(), Loading(), const Error(msg: cacheFailureMsg)];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(const GetConcreteNumberEvent(tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    const  tNumberTrivia = Number(text: 'test', number: 1);

    test('should get data from the random usecase', () async* {
      when(mockGetRandomNumber(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      bloc.add(GetRandomNumberEvent());
      await untilCalled(mockGetRandomNumber(any));
      verify(mockGetRandomNumber(NoParams()));
    });

    test('should emits [Loading, Loaded] when data is gotten successfully',
        () async* {
      when(mockGetRandomNumber(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      final expected = [Empty(), Loading(), const Loaded(number: tNumberTrivia)];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(GetRandomNumberEvent());
    });

    test('should emits [Loading, Error] when getting data fails', () async* {
      when(mockGetRandomNumber(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      final expected = [Empty(), Loading(), const Error(msg: serverFailureMsg)];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(GetRandomNumberEvent());
    });

    test(
        'should emits [Loading, Error] with a proper message for the error when getting data fails',
        () async* {
      when(mockGetRandomNumber(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [Empty(), Loading(), const Error(msg: cacheFailureMsg)];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(GetRandomNumberEvent());
    });
  });
}
