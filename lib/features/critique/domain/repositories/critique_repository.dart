import 'package:art_critique/features/critique/domain/entities/artwork.dart';
import 'package:art_critique/features/critique/domain/entities/persona_critique.dart';
import 'package:art_critique/features/critique/domain/entities/persona_id.dart';

abstract interface class CritiqueRepository {
  Future<PersonaCritique> getCritique(Artwork artwork, PersonaId personaId);
}
