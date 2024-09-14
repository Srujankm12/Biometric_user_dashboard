import 'package:application/core/errors/failure.dart';
import 'package:application/core/success/success.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthenticateUser{
  Future<Either<Failure , Success>> authenticateUser();
}