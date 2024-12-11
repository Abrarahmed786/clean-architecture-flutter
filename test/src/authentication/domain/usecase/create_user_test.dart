import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:project/src/authentication/domain/usecase/create_user.dart';

class MockAuthRepo extends Mock implements AuthenticationRepository {}

void main() {
  late CreateUser usecase;
  late AuthenticationRepository repository;
  setUp(() {
    repository = MockAuthRepo();
    usecase = CreateUser(repository);
  });
  const params = CreateUserParams.empty();
  test("It should call the [AuthenticationRepository.createUser()]", () async {
    // Arrenge
    when(
      () => repository.createUser(
        createdAt: any(named: 'createdAt'),
        name: any(named: 'name'),
        avatar: any(named: 'avatar'),
      ),
    ).thenAnswer((_) async => const Right(null));
    // Act
    final result = await usecase(params);
    // Assert

    expect(result, equals(const Right<dynamic, void>(null)));

    verify(
      () => repository.createUser(
          createdAt: params.createdAt,
          name: params.name,
          avatar: params.avatar),
    ).called(1);
    verifyNoMoreInteractions(repository);
  });
}
