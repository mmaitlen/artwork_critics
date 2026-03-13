import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:art_critique/features/critique/domain/entities/artwork.dart';
import 'package:art_critique/features/critique/domain/entities/persona_critique.dart';
import 'package:art_critique/features/critique/domain/entities/persona_id.dart';
import 'package:art_critique/features/critique/domain/repositories/critique_repository.dart';
import 'package:art_critique/features/critique/domain/usecases/get_all_critiques.dart';

class MockCritiqueRepository extends Mock implements CritiqueRepository {}

void main() {
  late MockCritiqueRepository mockRepository;
  late GetAllCritiques useCase;

  const artwork = Artwork(base64Image: 'test_base64', fileName: 'test.jpg');

  setUp(() {
    mockRepository = MockCritiqueRepository();
    useCase = GetAllCritiques(mockRepository);

    registerFallbackValue(artwork);
    registerFallbackValue(PersonaId.buyer);
  });

  test('returns a critique for each persona', () async {
    for (final persona in PersonaId.values) {
      when(() => mockRepository.getCritique(artwork, persona)).thenAnswer(
        (_) async => PersonaCritique(
          personaId: persona,
          critiqueText: '${persona.label} critique',
        ),
      );
    }

    final result = await useCase(artwork);

    expect(result.length, equals(PersonaId.values.length));
    expect(result.map((c) => c.personaId).toSet(), equals(PersonaId.values.toSet()));
    for (final critique in result) {
      verify(() => mockRepository.getCritique(artwork, critique.personaId)).called(1);
    }
  });

  test('propagates repository exception', () async {
    when(() => mockRepository.getCritique(any(), any()))
        .thenThrow(Exception('network error'));

    expect(() => useCase(artwork), throwsException);
  });
}
