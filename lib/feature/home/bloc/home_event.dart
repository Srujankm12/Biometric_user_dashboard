part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}


class HomeFetchMachinesEvent extends HomeEvent{}


class HomeLogoutEvent extends HomeEvent{}
