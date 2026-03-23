import 'package:project/core/usecase/usecase.dart';
import 'package:project/core/utils/typedef.dart';
import 'package:project/src/authentication/domain/entities/user.dart';
import 'package:project/src/authentication/domain/repositories/authentication_repository.dart';

class GetUser extends UsecaseWithoutParams<List<User>> {
  const GetUser(this._repository);
  final AuthenticationRepository _repository;
  @override
  ResultFuture<List<User>> call() async => _repository.getUser();
}
