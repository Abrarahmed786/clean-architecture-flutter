import 'dart:convert';

import 'package:project/core/utils/typedef.dart';
import 'package:project/src/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel(
      {required super.id,
      required super.createdAt,
      required super.name,
      required super.avatar});

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  UserModel.fromMap(DataMap map)
      : this(
          avatar: map['avatar'] as String,
          id: map['id'] as String,
          createdAt: map['createdAt'] as String,
          name: map['name'] as String,
        );

  UserModel copyWith({
    String? avatar,
    String? id,
    String? name,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      avatar: avatar,
      createdAt: '',
    );
  }

  DataMap toMap() => {
        'id': id,
        'avatar': avatar,
        'createdAt': createdAt,
        'name': name,
      };

  String toJson() => jsonEncode(toMap());
}
