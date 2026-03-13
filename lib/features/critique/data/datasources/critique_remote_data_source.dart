import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:art_critique/core/config/app_config.dart';
import 'package:art_critique/core/error/failures.dart';
import 'package:art_critique/features/critique/data/models/critique_response_model.dart';
import 'package:art_critique/features/critique/domain/entities/artwork.dart';
import 'package:art_critique/features/critique/domain/entities/persona_id.dart';

abstract interface class CritiqueRemoteDataSource {
  Future<CritiqueResponseModel> getCritique(Artwork artwork, PersonaId personaId);
}

class CritiqueRemoteDataSourceImpl implements CritiqueRemoteDataSource {
  final http.Client client;

  const CritiqueRemoteDataSourceImpl({required this.client});

  @override
  Future<CritiqueResponseModel> getCritique(
    Artwork artwork,
    PersonaId personaId,
  ) async {
    final response = await client.post(
      Uri.parse(AppConfig.critiqueFunctionUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'imageBase64': artwork.base64Image,
        'personaId': personaId.apiValue,
      }),
    );

    if (response.statusCode == 200) {
      return CritiqueResponseModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw ServerFailure('Critique request failed: ${response.statusCode}');
  }
}
