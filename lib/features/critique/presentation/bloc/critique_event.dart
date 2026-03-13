import 'package:equatable/equatable.dart';

import 'package:art_critique/features/critique/domain/entities/artwork.dart';

abstract class CritiqueEvent extends Equatable {
  const CritiqueEvent();

  @override
  List<Object?> get props => [];
}

class UploadArtworkAndCritique extends CritiqueEvent {
  final Artwork artwork;

  const UploadArtworkAndCritique(this.artwork);

  @override
  List<Object?> get props => [artwork];
}
