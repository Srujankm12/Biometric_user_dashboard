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

final class FetchAllStudentDetailsLoadingState extends DetailsState{}

final class DeleteStudentSuccessState extends DetailsState{
  final String message;
  DeleteStudentSuccessState({required this.message});
}

final class DeleteStudentFailedState extends DetailsState{
  final String error;
  DeleteStudentFailedState({required this.error});
}

final class DeleteLoadingState extends DetailsState{}

final class UpdateStudentSuccessState extends DetailsState{
  final String message;
  UpdateStudentSuccessState({required this.message});
}

final class UpdateStudentFailedState extends DetailsState{
  final String error;
  UpdateStudentFailedState({required this.error});
}

final class UpdateLoadingState extends DetailsState{}
