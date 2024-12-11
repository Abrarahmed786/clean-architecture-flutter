import 'package:get_it/get_it.dart';
import 'package:project/src/authentication/data/datasource/authentication_remote_data_source.dart';
import 'package:project/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:project/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:project/src/authentication/domain/usecase/create_user.dart';
import 'package:project/src/authentication/domain/usecase/get_user.dart';
import 'package:project/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // Cubit
  sl.registerFactory(() => AuthenticationCubit(
        createUser: sl(),
        getUser: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => CreateUser(sl()));
  sl.registerLazySingleton(() => GetUser(sl()));

  // Repository
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImplementation(sl()),
  );

  // Data Source
  sl.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => AuthenticationRemoteDataSourceImpl(sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
}
