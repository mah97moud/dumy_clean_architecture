import 'dart:convert';

import 'package:dumy_clean_architecture/core/utils/typedef.dart';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/user_model.dart';

abstract class AuthenticationRemoteDataSource {
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<List<UserModel>> getUsers();
}

const kCreateUserEndpoint = '/test/api/users';
const kGetUsersEndpoint = '/test/api/users';

class AuthRemoteDataSrcImpl implements AuthenticationRemoteDataSource {
  const AuthRemoteDataSrcImpl(this._client);

  final http.Client _client;

  @override
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    //1. check to make sure that it returns the right data when
    //the status code is 200
    // 2. check to make sure that it returns  Custom Exception when
    //the data is bad

    try {
      final response = await _client.post(
        Uri.https(kBaseUrl, kCreateUserEndpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'createdAt': createdAt,
            'name': name,
          },
        ),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw APIException(
          message: response.body,
          statusCode: 400,
        );
      }
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _client.get(
        Uri.https(kBaseUrl, kGetUsersEndpoint),
      );

      if (response.statusCode != 200) {
        throw APIException(
          message: response.body,
          statusCode: 400,
        );
      }

      return List<DataMap>.from(jsonDecode(response.body) as List)
          .map((userData) => UserModel.fromMap(userData))
          .toList();
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }
}
