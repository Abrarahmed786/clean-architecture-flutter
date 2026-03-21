import 'package:equatable/equatable.dart';

class APIExceptions extends Equatable implements Exception {
  const APIExceptions({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}
