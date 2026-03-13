import 'package:art_critique/features/critique/domain/entities/artwork.dart';
import 'package:art_critique/features/critique/domain/entities/persona_critique.dart';
import 'package:art_critique/features/critique/domain/entities/persona_id.dart';
import 'package:art_critique/features/critique/domain/repositories/critique_repository.dart';

class GetAllCritiques {
  final CritiqueRepository repository;

  const GetAllCritiques(this.repository);

  Future<List<PersonaCritique>> call(Artwork artwork) async {
    final results = await Future.wait(
      PersonaId.values.map((id) => repository.getCritique(artwork, id)),
    );
    return results;
  }
}
