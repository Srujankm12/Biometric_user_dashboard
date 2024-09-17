part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class RegisterStudentEvent extends RegisterEvent {
  final String studentName;
  final String studentUSN;
  final String studentDepartment;
  final String unitID;
  final String studentUnitId;
  final String fingerprint;
  final String port;
  RegisterStudentEvent({
    required this.studentName,
    required this.studentUSN,
    required this.studentDepartment,
    required this.studentUnitId,
    required this.unitID,
    required this.fingerprint,
    required this.port,
  });
}

class FetchMachinesEvent extends RegisterEvent{}

class FetchStudentUnitIdEvent extends RegisterEvent{
  final String unitID;
  FetchStudentUnitIdEvent({required this.unitID});
}

class FetchComPortsEvent extends RegisterEvent{}
