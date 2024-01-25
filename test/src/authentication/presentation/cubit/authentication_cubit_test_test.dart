import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dumy_clean_architecture/core/errors/failure.dart';
import 'package:dumy_clean_architecture/src/authentication/domain/usecases/create_user.dart';
import 'package:dumy_clean_architecture/src/authentication/domain/usecases/get_users.dart';
import 'package:dumy_clean_architecture/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements CreateUser {}

void main() {
  late GetUsers getUsers;
  late CreateUser createUser;
  late AuthenticationCubit cubit;

  const tCreateUserParams = CreateUserParams.empty();
  const tAPIFailure = ApiFailure(
    message: 'Something went wrong',
    statusCode: 500,
  );

  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUser();
    cubit = AuthenticationCubit(getUsers: getUsers, createUser: createUser);
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() {
    cubit.close();
  });

  test(
    'initial state should be  [AuthenticationInitial]',
    () async {
      expect(cubit.state, AuthenticationInitial());
    },
  );

  group('createUser', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [CreatingUser, UserCreated] '
      'when createUser is successful',
      build: () {
        when(() => createUser(any())).thenAnswer(
          (_) async => const Right(null),
        );

        return cubit;
      },
      act: (cubit) => cubit.createUser(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
      ),
      expect: () => const [CreatingUser(), UserCreated()],
      verify: (_) {
        verify(
          () => createUser(tCreateUserParams),
        );
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [CreatingUser, AuthenticationError] '
      'when createUser is successful',
      build: () {
        when(() => createUser(any())).thenAnswer(
          (_) async => const Left(tAPIFailure),
        );

        return cubit;
      },
      act: (cubit) => cubit.createUser(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
      ),
      expect: () => [
        const CreatingUser(),
        AuthenticationError(tAPIFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => createUser(tCreateUserParams),
        );
      },
    );
  });

  group('getUsers', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUsers, UsersLoaded] '
      'when getUsers is successful',
      build: () {
        when(() => getUsers()).thenAnswer(
          (_) async => const Right([]),
        );

        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => const [GettingUsers(), UsersLoaded([])],
      verify: (_) {
        verify(
          () => getUsers(),
        );
        verifyNoMoreInteractions(getUsers);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUsers, AuthenticationError] '
      'when getUsers has error',
      build: () {
        when(() => getUsers()).thenAnswer(
          (_) async => const Left(tAPIFailure),
        );

        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => [
        const GettingUsers(),
        AuthenticationError(tAPIFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => getUsers(),
        );
        verifyNoMoreInteractions(getUsers);
      },
    );
  });
}