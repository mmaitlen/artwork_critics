import 'package:equatable/equatable.dart';
import 'package:art_critique/features/critique/domain/entities/persona_id.dart';

class PersonaCritique extends Equatable {
  final PersonaId personaId;
  final String critiqueText;

  const PersonaCritique({
    required this.personaId,
    required this.critiqueText,
  });

  @override
  List<Object> get props => [personaId, critiqueText];
}
