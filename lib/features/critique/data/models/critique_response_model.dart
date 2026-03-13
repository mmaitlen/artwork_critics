import 'package:art_critique/features/critique/domain/entities/persona_critique.dart';
import 'package:art_critique/features/critique/domain/entities/persona_id.dart';

class CritiqueResponseModel {
  final String critique;

  const CritiqueResponseModel({required this.critique});

  factory CritiqueResponseModel.fromJson(Map<String, dynamic> json) {
    return CritiqueResponseModel(critique: json['critique'] as String);
  }

  PersonaCritique toEntity(PersonaId personaId) {
    return PersonaCritique(personaId: personaId, critiqueText: critique);
  }
}
