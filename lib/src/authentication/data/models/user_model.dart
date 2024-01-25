import 'dart:convert';

import '../../../../core/utils/typedef.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.createdAt,
    required super.name,
    required super.avatar,
  });

  const UserModel.empty()
      : super(
          id: '1',
          createdAt: '2024-01-22T23:42:26.529Z',
          name: 'Nelson Stroman Sr.',
          avatar: 'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/40.jpg',
        );

  UserModel copyWith({
    String? id,
    String? createdAt,
    String? name,
    String? avatar,
  }) {
    return UserModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }

  factory UserModel.fromJson(String json) => UserModel.fromMap(
        jsonDecode(
          json,
        ),
      );
  UserModel.fromMap(DataMap map)
      : this(
          avatar: map['avatar'] as String,
          createdAt: map['createdAt'] as String,
          id: map['id'] as String,
          name: map['name'] as String,
        );

  DataMap toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'name': name,
      'avatar': avatar,
    };
  }

  String toJson() => jsonEncode(toMap());
}