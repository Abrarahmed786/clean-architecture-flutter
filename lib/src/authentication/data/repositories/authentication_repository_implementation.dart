import 'package:dartz/dartz.dart';
import 'package:project/core/errors/exceptions.dart';
import 'package:project/core/errors/failure.dart';
import 'package:project/core/utils/typedef.dart';
import 'package:project/src/authentication/data/datasource/authentication_remote_data_source.dart';
import 'package:project/src/authentication/domain/entities/user.dart';
import 'package:project/src/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  const AuthenticationRepositoryImplementation(this._remoteDataSource);

  final AuthenticationRemoteDataSource _remoteDataSource;

  @override
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    try {
      await _remoteDataSource.createUser(
        name: name,
        createdAt: createdAt,
        avatar: avatar,
      );
      return const Right(null);
    } on APIExceptions catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<User>> getUser() async {
    try {
      final userModels = await _remoteDataSource.getUser();
      final users = userModels.map((model) => model.toEntity()).toList();
      return Right(users);
    } on APIExceptions catch (e) {
      return Left(ApiFailure.fromException(e));
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 505));
    }
  }
}
