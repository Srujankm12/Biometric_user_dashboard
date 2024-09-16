part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}


final class RegisterLoadingState extends RegisterState{}


final class RegisterFailureState extends RegisterState{
  final String err;
  RegisterFailureState({required this.err});
}

final class RegisterTakeFingerState extends RegisterState{}


final class RegisterSuccessState extends RegisterState{
  final String message;
  RegisterSuccessState({required this.message});
}
