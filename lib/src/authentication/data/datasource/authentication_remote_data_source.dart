import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/core/errors/exceptions.dart';
import 'package:project/src/authentication/data/models/user_model.dart';

/// Mock API base; keep in one place for tests and environment overrides later.
const _kUsersBaseUrl = 'https://6751d547d1983b9597b4878e.mockapi.io/users';

abstract class AuthenticationRemoteDataSource {
  Future<void> createUser({
    required String name,
    required String createdAt,
    required String avatar,
  });

  Future<List<UserModel>> getUser();
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  AuthenticationRemoteDataSourceImpl(this._client);
  final http.Client _client;

  @override
  Future<void> createUser({
    required String name,
    required String createdAt,
    required String avatar,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(_kUsersBaseUrl),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'createdAt': createdAt,
          'name': name,
          'avatar': avatar,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw APIExceptions(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is APIExceptions) rethrow;
      throw APIExceptions(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUser() async {
    try {
      final response = await _client.get(Uri.parse(_kUsersBaseUrl));

      if (response.statusCode != 200) {
        throw APIExceptions(
          message: response.body,
          statusCode: response.statusCode,
        );
      }

      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((dynamic user) => UserModel.fromMap(user as Map<String, dynamic>))
          .toList(growable: false);
    } catch (e) {
      if (e is APIExceptions) rethrow;
      throw APIExceptions(message: e.toString(), statusCode: 505);
    }
  }
}
