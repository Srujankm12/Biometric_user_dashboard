part of 'logs_bloc.dart';

@immutable
sealed class LogsState {}

final class LogsInitial extends LogsState {}

final class FetchStudentLogsSuccessState extends LogsState{
  final List<dynamic> data;
  FetchStudentLogsSuccessState({required this.data});
}

final class FetchStudentLogsFailedState extends LogsState{
  final String error;
  FetchStudentLogsFailedState({required this.error});
}

final class FetchStudentLogsLoadingState extends LogsState{}
