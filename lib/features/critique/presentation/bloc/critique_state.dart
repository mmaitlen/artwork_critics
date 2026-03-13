import 'package:equatable/equatable.dart';

import 'package:art_critique/features/critique/domain/entities/persona_critique.dart';

abstract class CritiqueState extends Equatable {
  const CritiqueState();

  @override
  List<Object?> get props => [];
}

class CritiqueInitial extends CritiqueState {
  const CritiqueInitial();
}

class CritiqueLoading extends CritiqueState {
  const CritiqueLoading();
}

class CritiqueLoaded extends CritiqueState {
  final List<PersonaCritique> critiques;

  const CritiqueLoaded(this.critiques);

  @override
  List<Object?> get props => [critiques];
}

class CritiqueError extends CritiqueState {
  final String message;

  const CritiqueError(this.message);

  @override
  List<Object?> get props => [message];
}
