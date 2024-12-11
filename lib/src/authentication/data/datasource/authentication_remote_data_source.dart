import 'dart:convert';
import 'package:project/core/errors/exceptions.dart';
import 'package:project/src/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;

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
        Uri.parse("https://6751d547d1983b9597b4878e.mockapi.io/users"),
        headers: {'Content-Type': 'application/json'},
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
    } on APIExceptions {
      rethrow;
    } catch (e) {
      throw APIExceptions(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUser() async {
    try {
      final response = await _client.get(
        Uri.parse("https://6751d547d1983b9597b4878e.mockapi.io/users"),
      );

      if (response.statusCode != 200) {
        throw APIExceptions(
          message: response.body,
          statusCode: response.statusCode,
        );
      }

      final List<dynamic> data = jsonDecode(response.body);
      return data.map((user) => UserModel.fromMap(user)).toList();
    } on APIExceptions {
      rethrow;
    } catch (e) {
      throw APIExceptions(message: e.toString(), statusCode: 505);
    }
  }
}
