import 'dart:convert';

import 'package:dumy_clean_architecture/core/errors/exceptions.dart';
import 'package:dumy_clean_architecture/core/utils/constants.dart';
import 'package:dumy_clean_architecture/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:dumy_clean_architecture/src/authentication/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthRemoteDataSrcImpl(client);
    registerFallbackValue(Uri());
  });

  final tSuccessResponse = http.Response('User Created Successfully', 201);

  group('createUser', () {
    test('should complete successfully when the status code is 200 or 201',
        () async {
      when(
        () => client.post(
          any(),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async {
        return tSuccessResponse;
      });

      final methodCall = remoteDataSource.createUser;

      expect(
          methodCall(
            createdAt: 'createdAt',
            name: 'name',
            avatar: 'avatar',
          ),
          completes);

      verify(
        () => client.post(
            Uri.https(kBaseUrl, kCreateUserEndpoint),
          body: jsonEncode({
            'createdAt': 'createdAt',
            'name': 'name',
            'avatar': 'avatar',
          }),
        ),
      ).called(1);
      verifyNoMoreInteractions(client);
    });

    var tErrorResponse =
        http.Response('Invalid Email Address or Password', 400);

    test('should throw [APIException] when the status code is not 200 or 201',
        () async {
      when(
        () => client.post(
          any(),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async {
        return tErrorResponse;
      });

      final methodCall = remoteDataSource.createUser;

      expect(
        () async => methodCall(
          createdAt: 'createdAt',
          name: 'name',
          avatar: 'avatar',
        ),
        throwsA(
          const APIException(
            message: 'Invalid Email Address or Password',
            statusCode: 400,
          ),
        ),
      );

      verify(
        () => client.post(
          Uri.https(kBaseUrl, kCreateUserEndpoint),
          body: jsonEncode({
            'createdAt': 'createdAt',
            'name': 'name',
            'avatar': 'avatar',
          }),
        ),
      ).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group('getUsers', () {
    const tUsers = [UserModel.empty()];
    test(
      'should return [List<UserModel>] when the status code is 200',
      () async {
        when(
          () => client.get(
            any(),
          ),
        ).thenAnswer((_) async {
          return http.Response(
            jsonEncode(
              [tUsers.first.toMap()],
            ),
            200,
          );
        });

        final result = await remoteDataSource.getUsers();
        expect(result, equals(tUsers));
        verify(
          () => client.get(
            Uri.https(
              kBaseUrl,
              kGetUsersEndpoint,
            ),
          ),
        ).called(1);
        verifyNoMoreInteractions(client);
      },
    );


    test(
      'should throw [APIException] when the status code is not 200',
      () async {
        when(
          () => client.get(
            any(),
          ),
        ).thenAnswer((_) async {
          return http.Response(
            jsonEncode(
              [tUsers.first.toMap()],
            ),
            400,
          );
        });

        final result = remoteDataSource.getUsers();
        expect(result, throwsA(isA<APIException>()));
        verify(
          () => client.get(
            Uri.https(
              kBaseUrl,
              kGetUsersEndpoint,
            ),
          ),
        ).called(1);
        verifyNoMoreInteractions(client);

      },
    );
 
 
  });
}
