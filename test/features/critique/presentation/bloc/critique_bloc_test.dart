import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:art_critique/features/critique/domain/entities/artwork.dart';
import 'package:art_critique/features/critique/domain/entities/persona_critique.dart';
import 'package:art_critique/features/critique/domain/entities/persona_id.dart';
import 'package:art_critique/features/critique/domain/repositories/critique_repository.dart';
import 'package:art_critique/features/critique/domain/usecases/get_all_critiques.dart';
import 'package:art_critique/features/critique/presentation/bloc/critique_bloc.dart';
import 'package:art_critique/features/critique/presentation/bloc/critique_event.dart';
import 'package:art_critique/features/critique/presentation/bloc/critique_state.dart';

class MockCritiqueRepository extends Mock implements CritiqueRepository {}

void main() {
  late MockCritiqueRepository mockRepository;
  late GetAllCritiques getAllCritiques;

  const artwork = Artwork(base64Image: 'test_base64', fileName: 'test.jpg');

  final stubCritiques = PersonaId.values
      .map((p) => PersonaCritique(personaId: p, critiqueText: '${p.label} says something'))
      .toList();

  setUp(() {
    mockRepository = MockCritiqueRepository();
    getAllCritiques = GetAllCritiques(mockRepository);

    registerFallbackValue(artwork);
    registerFallbackValue(PersonaId.buyer);

    for (final critique in stubCritiques) {
      when(() => mockRepository.getCritique(artwork, critique.personaId))
          .thenAnswer((_) async => critique);
    }
  });

  group('UploadArtworkAndCritique', () {
    blocTest<CritiqueBloc, CritiqueState>(
      'emits [loading, loaded] on success',
      build: () => CritiqueBloc(getAllCritiques: getAllCritiques),
      act: (bloc) => bloc.add(const UploadArtworkAndCritique(artwork)),
      expect: () => [
        const CritiqueLoading(),
        CritiqueLoaded(stubCritiques),
      ],
    );

    blocTest<CritiqueBloc, CritiqueState>(
      'emits [loading, error] on repository failure',
      build: () {
        when(() => mockRepository.getCritique(any(), any()))
            .thenThrow(Exception('network error'));
        return CritiqueBloc(getAllCritiques: getAllCritiques);
      },
      act: (bloc) => bloc.add(const UploadArtworkAndCritique(artwork)),
      expect: () => [
        const CritiqueLoading(),
        isA<CritiqueError>(),
      ],
    );

    blocTest<CritiqueBloc, CritiqueState>(
      'initial state is CritiqueInitial',
      build: () => CritiqueBloc(getAllCritiques: getAllCritiques),
      verify: (bloc) => expect(bloc.state, const CritiqueInitial()),
    );
  });
}
