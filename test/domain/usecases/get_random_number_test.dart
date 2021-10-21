import 'package:dartz/dartz.dart';
import 'package:flutter_number_game/core/usecases/usecase.dart';
import 'package:flutter_number_game/domain/entities/number.dart';
import 'package:flutter_number_game/domain/repository/number_repository.dart';
import 'package:flutter_number_game/domain/usecases/get_random_number.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberRepository extends Mock implements NumberRepository {}

void main() {
  late MockNumberRepository mockNumberRepository;
  late GetRandomNumber usecase;
  late Number tNumberInfo;

  setUp(() {
    mockNumberRepository = MockNumberRepository();
    usecase = GetRandomNumber(mockNumberRepository);
    tNumberInfo = Number(text: 'text', number: 1);
  });

  test('get random info from repository', () async {
    when(mockNumberRepository.getRandomNumber())
        .thenAnswer((realInvocation) async => Right(tNumberInfo));

    final res = await usecase(NoParams());

    expect(res, Right(tNumberInfo));
    verify(mockNumberRepository.getRandomNumber());
    verifyNoMoreInteractions(mockNumberRepository);
  });
}