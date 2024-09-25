part of 'download_bloc.dart';

@immutable
sealed class DownloadEvent {}


class FetchBiometricUnitsEvent extends DownloadEvent{}


class DownloadExcelEvent extends DownloadEvent{
  final String startDate;
  final String endDate;
  final String unitId;
  DownloadExcelEvent({required this.startDate , required this.endDate , required this.unitId});
}
