part of 'logs_bloc.dart';

@immutable
sealed class LogsEvent {}


class FetchStudentLogs extends LogsEvent{
  final String studentID;
  FetchStudentLogs({required this.studentID});
}
