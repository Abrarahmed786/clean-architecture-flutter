part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class CreateUserEvents extends AuthenticationEvent {
  final String createdAt;
  final String name;
  final String avatar;

  const CreateUserEvents({
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

  @override
  List<Object> get props => [createdAt, name, avatar];
}

class GetUserEvent extends AuthenticationEvent {
  const GetUserEvent();
}
