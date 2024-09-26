part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoadingState extends RegisterState{}


final class FetchFingerprintMachineSuccessState extends RegisterState{
  final List<String> data;
  FetchFingerprintMachineSuccessState({required this.data});
}

final class FetchFingerprintMachineFailureState extends RegisterState{
  final String errorMessage;
  FetchFingerprintMachineFailureState({required this.errorMessage});
}


final class FetchStudentUnitIdSuccessState extends RegisterState{
  final List<String> data;
  FetchStudentUnitIdSuccessState({required this.data});
}

final class FetchStudentUnitIdFailureState extends RegisterState{
  final String errorMessage;
  FetchStudentUnitIdFailureState({required this.errorMessage});
}

final class FetchFingerprintMachinePortSuccessState extends RegisterState{
  final List<String> data;
  FetchFingerprintMachinePortSuccessState({required this.data});
}


final class FetchFingerprintMachinePortFailureState extends RegisterState{
  final String errorMessage;
  FetchFingerprintMachinePortFailureState({required this.errorMessage});
}


final class VerifyDetailsSuccessState extends RegisterState{}


final class VerifyDetailsFailureState extends RegisterState{
  final String errorMessage;
  VerifyDetailsFailureState({required this.errorMessage});
}

final class RegisterStudentSuccessState extends RegisterState{}

final class RegisterStudentAccnoledgementState extends RegisterState{
  final double animationValue;
  final int status;
  final String message;
  RegisterStudentAccnoledgementState({required this.message , required this.status , required this.animationValue});
}

final class RegisterStudentFailureState extends RegisterState{
  final String errorMessage;
  RegisterStudentFailureState({required this.errorMessage});
}




