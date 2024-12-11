import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project/src/authentication/domain/entities/user.dart';
import 'package:project/src/authentication/domain/usecase/create_user.dart';
import 'package:project/src/authentication/domain/usecase/get_user.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required CreateUser createUser,
    required GetUser getUser,
  })  : _createUser = createUser,
        _getUser = getUser,
        super(const AutheticationInitial()) {
    on<CreateUserEvents>(_createUserHandler);
    on<GetUserEvent>(_getUserHandler);
  }
  final CreateUser _createUser;
  final GetUser _getUser;

  Future<void> _createUserHandler(
    CreateUserEvents event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const CreatingUser());

    final result = await _createUser(CreateUserParams(
      createdAt: event.createdAt,
      name: event.name,
      avatar: event.avatar,
    ));

    result.fold(
        (failure) => emit(AuthenticationError(
            "${failure.statusCode}, Error ${failure.message}")),
        (_) => emit(const UserCreated()));
  }

  Future<void> _getUserHandler(
    GetUserEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const GettingUser());
    final result = await _getUser();
    result.fold(
        (failure) => emit(AuthenticationError(
            "${failure.statusCode}, Error ${failure.message}")),
        (users) => emit(UsersLoaded(users)));
  }
}
