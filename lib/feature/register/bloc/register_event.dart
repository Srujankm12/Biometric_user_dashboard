part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class RegisterStudentEvent extends RegisterEvent {
  final String studentName;
  final String studentUSN;
  final String studentDepartment;
  final String unitID;
  final String studentUnitId;
  RegisterStudentEvent({
    required this.studentName,
    required this.studentUSN,
    required this.studentDepartment,
    required this.studentUnitId,
    required this.unitID,
  });
}
