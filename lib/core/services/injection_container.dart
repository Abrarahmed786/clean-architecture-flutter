import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:project/src/authentication/data/datasource/authentication_remote_data_source.dart';
import 'package:project/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:project/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:project/src/authentication/domain/usecase/create_user.dart';
import 'package:project/src/authentication/domain/usecase/get_user.dart';
import 'package:project/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:project/src/authentication/presentation/cubit/authentication_cubit.dart';

final sl = GetIt.instance;

/// [httpClient] is optional so tests can inject [MockClient] without touching prod wiring.
Future<void> init({http.Client? httpClient}) async {
  if (httpClient != null) {
    sl.registerSingleton<http.Client>(httpClient);
  } else {
    sl.registerLazySingleton<http.Client>(http.Client.new);
  }

  sl.registerFactory(
    () => AuthenticationBloc(
      createUser: sl(),
      getUser: sl(),
    ),
  );
  sl.registerFactory(
    () => AuthenticationCubit(
      createUser: sl(),
      getUser: sl(),
    ),
  );

  sl.registerLazySingleton(() => CreateUser(sl()));
  sl.registerLazySingleton(() => GetUser(sl()));

  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImplementation(sl()),
  );

  sl.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => AuthenticationRemoteDataSourceImpl(sl()),
  );
}
