import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:art_critique/features/critique/domain/usecases/get_all_critiques.dart';
import 'package:art_critique/features/critique/presentation/bloc/critique_event.dart';
import 'package:art_critique/features/critique/presentation/bloc/critique_state.dart';

class CritiqueBloc extends Bloc<CritiqueEvent, CritiqueState> {
  final GetAllCritiques getAllCritiques;

  CritiqueBloc({required this.getAllCritiques}) : super(const CritiqueInitial()) {
    on<UploadArtworkAndCritique>(_onUploadArtworkAndCritique);
  }

  Future<void> _onUploadArtworkAndCritique(
    UploadArtworkAndCritique event,
    Emitter<CritiqueState> emit,
  ) async {
    emit(const CritiqueLoading());
    try {
      final critiques = await getAllCritiques(event.artwork);
      emit(CritiqueLoaded(critiques));
    } catch (e) {
      emit(CritiqueError(e.toString()));
    }
  }
}
