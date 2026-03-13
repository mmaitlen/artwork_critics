import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:art_critique/features/critique/data/datasources/critique_remote_data_source.dart';
import 'package:art_critique/features/critique/data/repositories/critique_repository_impl.dart';
import 'package:art_critique/features/critique/domain/repositories/critique_repository.dart';
import 'package:art_critique/features/critique/domain/usecases/get_all_critiques.dart';
import 'package:art_critique/features/critique/presentation/bloc/critique_bloc.dart';

final sl = GetIt.instance;

void configureDependencies() {
  // External
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Data sources
  sl.registerLazySingleton<CritiqueRemoteDataSource>(
    () => CritiqueRemoteDataSourceImpl(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<CritiqueRepository>(
    () => CritiqueRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllCritiques(sl()));

  // BLoC (factory — new instance per creation)
  sl.registerFactory(() => CritiqueBloc(getAllCritiques: sl()));
}
