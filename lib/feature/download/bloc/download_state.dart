part of 'download_bloc.dart';

@immutable
sealed class DownloadState {}

final class DownloadInitial extends DownloadState {}

final class DownloadLoadingState extends DownloadState{}

final class FetchBiometricUnitsSuccessState extends DownloadState{
    final List<String> data;
  FetchBiometricUnitsSuccessState({required this.data});
}

final class FetchBiometricUnitsFailedState extends DownloadState{
  final String message;
  FetchBiometricUnitsFailedState({required this.message});
}

final class DownloadExcelSuccessState extends DownloadState{
  final String message;
  DownloadExcelSuccessState({required this.message});
}

final class DownloadExcelFailedState extends DownloadState{
  final String message;
  DownloadExcelFailedState({required this.message});
}
