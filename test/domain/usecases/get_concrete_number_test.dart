import 'package:dartz/dartz.dart';
import 'package:flutter_number_game/domain/entities/number.dart';
import 'package:flutter_number_game/domain/repository/number_repository.dart';
import 'package:flutter_number_game/domain/usecases/get_concrete_number.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberRepository extends Mock implements NumberRepository {}

void main() {
  late MockNumberRepository mockNumberRepository;
  late GetConcreteNumber usecase;
  late int tNumber;
  late Number tNumberInfo;

  setUp(() {
    mockNumberRepository = MockNumberRepository();
    usecase = GetConcreteNumber(mockNumberRepository);
    tNumber = 1;
    tNumberInfo = const Number(text: 'text', number: 1);
  });

  test('get number info from repository', () async {
    when(mockNumberRepository.getConcreteNumber(tNumber))
        .thenAnswer((realInvocation) async => Right(tNumberInfo));

    final res = await usecase(Params(number: tNumber));

    expect(res, Right(tNumberInfo));
    verify(mockNumberRepository.getConcreteNumber(tNumber));
    verifyNoMoreInteractions(mockNumberRepository);
  });
}
