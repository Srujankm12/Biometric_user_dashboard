part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}


final class HomeMachinesFetchSuccessState extends HomeState{
  final List getMachines;
  HomeMachinesFetchSuccessState({required this.getMachines});
}


final class HomeMachinesFetchFailureState extends HomeState{
  final String err;
  HomeMachinesFetchFailureState({required this.err});
}


final class HomeMachinesLogoutState extends HomeState{}
