import 'package:dumy_clean_architecture/core/errors/failure.dart';
import 'package:equatable/equatable.dart';

class APIException extends Equatable implements Failure {

 const APIException({
  required this.message,
  required this.statusCode,
 });

  @override
  final String message;
  @override
  final int statusCode;
  
  @override
 
  List<Object?> get props =>[
    message,
    statusCode,
  ];

  @override
  // TODO: implement errorMessage
  String get errorMessage => throw UnimplementedError();
}