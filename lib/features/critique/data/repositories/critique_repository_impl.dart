import 'package:art_critique/features/critique/data/datasources/critique_remote_data_source.dart';
import 'package:art_critique/features/critique/domain/entities/artwork.dart';
import 'package:art_critique/features/critique/domain/entities/persona_critique.dart';
import 'package:art_critique/features/critique/domain/entities/persona_id.dart';
import 'package:art_critique/features/critique/domain/repositories/critique_repository.dart';

class CritiqueRepositoryImpl implements CritiqueRepository {
  final CritiqueRemoteDataSource remoteDataSource;

  const CritiqueRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PersonaCritique> getCritique(Artwork artwork, PersonaId personaId) async {
    final model = await remoteDataSource.getCritique(artwork, personaId);
    return model.toEntity(personaId);
  }
}
