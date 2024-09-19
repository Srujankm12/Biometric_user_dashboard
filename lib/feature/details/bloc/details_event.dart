part of 'details_bloc.dart';

@immutable
sealed class DetailsEvent {}


class FetchAllStudentDetailsEvent extends DetailsEvent{
  final String unitId;
  FetchAllStudentDetailsEvent({required this.unitId});
}

class DeleteStudentEvent extends DetailsEvent{
  final String studentId;
  final String studentUnitId;
  final String unitId;
  DeleteStudentEvent({required this.studentId , required this.studentUnitId , required this.unitId});
}

class UpdateStudentEvent extends DetailsEvent{
  final String name;
  final String usn;
  final String branch;
  final String unit;
  final String studentID;
  UpdateStudentEvent({required this.branch , required this.name , required this.usn , required this.unit , required this.studentID});
}
