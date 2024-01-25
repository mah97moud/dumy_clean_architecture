import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repositories/authentication_repository.dart';

class CreateUser extends UseCaseWithParams<void, CreateUserParams> {
  const CreateUser(this._repository);
  final AuthenticationRepository _repository;

  @override
  ResultFuture call(params) async => _repository.createUser(
        createdAt: params.createdAt,
        name: params.name,
        avatar: params.avatar,
      );
}

class CreateUserParams extends Equatable {
  const CreateUserParams({
    required this.createdAt,
    required this.name,
    required this.avatar,
  });
  final String createdAt;
  final String name;
  final String avatar;

  const CreateUserParams.empty()
      : this(
          createdAt: '_empty.string',
          name: '_empty.string',
          avatar: '_empty.string',
        );

  @override
  List<Object?> get props => [createdAt, name, avatar];
}