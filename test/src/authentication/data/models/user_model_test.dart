import 'dart:convert';
import 'dart:io';

import 'package:dumy_clean_architecture/core/utils/typedef.dart';
import 'package:dumy_clean_architecture/src/authentication/data/models/user_model.dart';
import 'package:dumy_clean_architecture/src/authentication/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tModel = UserModel.empty();

  test('should be a subclass of [User] entity', () {
    const tModel = UserModel.empty();

    expect(tModel, isA<User>());
  });

  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson) as DataMap;

  group('fromMap', () {
    test('should return a UserModel with right data', () {
      // Act
      final result = UserModel.fromMap(tMap);
      // Assert
      expect(
        result,
        equals(
          UserModel.empty(),
        ),
      );
    });
  });
  group('fromJson', () {
    test('should return a UserModel with right data', () {
      // Act
      final result = UserModel.fromJson(tJson);
      // Assert
      expect(
        result,
        equals(
          UserModel.empty(),
        ),
      );
    });
  });

  group('toMap', () {
    test('should return a UserModel with right data', () {
      // Act
      final result = tModel.toMap();
      // Assert
      expect(
        result,
        equals(
          tMap,
        ),
      );
    });
  });

  group('toJson', () {
    test('should return a UserModel with right data', () {
      // Act
      final result = tModel.toJson();
      // Assert
      expect(
        result,
        equals(
          tModel.toJson(),
        ),
      );
    });
  });

  group('copyWith', () {
    test('should return a [UserModel] with different data',(){
      // Arrange

      // Act
      final result = tModel.copyWith(
          name: 'Paul'
      );
      expect(result.name, equals('Paul'));
    });
  });
}