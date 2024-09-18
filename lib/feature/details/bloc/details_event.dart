part of 'details_bloc.dart';

@immutable
sealed class DetailsEvent {}


class FetchAllStudentDetailsEvent extends DetailsEvent{
  final String unitId;
  FetchAllStudentDetailsEvent({required this.unitId});
}
