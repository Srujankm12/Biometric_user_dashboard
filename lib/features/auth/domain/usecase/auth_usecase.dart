import 'package:application/core/errors/failure.dart';
import 'package:application/core/success/success.dart';
import 'package:application/core/usecase/usecase.dart';
import 'package:application/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class LoginUser implements UseCase<Success>{
  final AuthenticateUser authUser;
  LoginUser({required this.authUser});

  @override
  Future<Either<Failure, Success>> call() {
    return authUser.authenticateUser();
  }
}