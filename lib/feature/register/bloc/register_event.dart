part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class FetchFingerprintMachinesEvent extends RegisterEvent {}

class FetchStudentUnitIdEvent extends RegisterEvent {
  final String unitId;
  FetchStudentUnitIdEvent({required this.unitId});
}

class FetchFingerprintMachinePortEvent extends RegisterEvent {
  final String ports;
  FetchFingerprintMachinePortEvent({required this.ports});
}

class VerifyDetailsEvent extends RegisterEvent {
  final String studentName;
  final String studentUSN;
  final String studentDepartment;
  final String unitID;
  final String studentUnitId;
  final String port;
  VerifyDetailsEvent({
    required this.port,
    required this.studentDepartment,
    required this.studentName,
    required this.studentUSN,
    required this.studentUnitId,
    required this.unitID,
  });
}

class RegisterStudentEvent extends RegisterEvent {
  final String studentName;
  final String studentUSN;
  final String studentDepartment;
  final String unitID;
  final String studentUnitId;
  final String port;
  RegisterStudentEvent({
    required this.studentName,
    required this.studentUSN,
    required this.studentDepartment,
    required this.studentUnitId,
    required this.unitID,
    required this.port,
  });
}
