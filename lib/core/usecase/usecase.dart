import 'package:application/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UseCase<SuccessType> {
  Future<Either<Failure , SuccessType>> call();
}