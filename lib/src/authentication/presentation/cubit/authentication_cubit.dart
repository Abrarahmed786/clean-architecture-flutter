import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project/core/errors/failure.dart';
import 'package:project/src/authentication/domain/entities/user.dart';
import '../../domain/usecase/create_user.dart';
import '../../domain/usecase/get_user.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({
    required CreateUser createUser,
    required GetUser getUser,
  })  : _createUser = createUser,
        _getUser = getUser,
        super(const AuthenticationInitial());

  final CreateUser _createUser;
  final GetUser _getUser;

  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    emit(const CreatingUser());

    final result = await _createUser(CreateUserParams(
      createdAt: createdAt,
      name: name,
      avatar: avatar,
    ));
    result.fold(
      (failure) => emit(AuthenticationError(failure.displayMessage)),
      (_) => emit(const UserCreated()),
    );
  }

  Future<void> getUser() async {
    emit(const GettingUser());
    final result = await _getUser();
    result.fold(
      (failure) => emit(AuthenticationError(failure.displayMessage)),
      (users) => emit(UsersLoaded(users)),
    );
  }
}
