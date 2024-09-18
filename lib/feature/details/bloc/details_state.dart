part of 'details_bloc.dart';

@immutable
sealed class DetailsState {}

final class DetailsInitial extends DetailsState {}

final class FetchAllStudentSuccessState extends DetailsState{
  final List<dynamic> data;
  FetchAllStudentSuccessState({required this.data});
}

final class FetchAllStudentFailureState extends DetailsState{
  final String message;
  FetchAllStudentFailureState({required this.message});
}