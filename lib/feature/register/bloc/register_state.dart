part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}


final class RegisterLoadingState extends RegisterState{}


final class RegisterFailureState extends RegisterState{
  final String err;
  RegisterFailureState({required this.err});
}


final class RegisterSuccessState extends RegisterState{
  final String message;
  RegisterSuccessState({required this.message});
}

// Class To Fetch Units
final class FetchMachinesSuccessState extends RegisterState{
  final List<String> data;
  FetchMachinesSuccessState({required this.data});
}

// Class To Fetch Student_Units
final class FetchStudentUnitIdSuccessState extends RegisterState{
  final List<String> data;
  FetchStudentUnitIdSuccessState({required this.data});
}

// Class To Fetch Ports
final class FetchAllPortsSuccessState extends RegisterState{
  final List<String> data;
  FetchAllPortsSuccessState({required this.data});
}

final class RegisterAcknowledgmentState extends RegisterState {
  final String message;
  final double fingerprintstatus;
  RegisterAcknowledgmentState({required this.message , required this.fingerprintstatus});
}

final class ComPortSelectedState extends RegisterState{}
