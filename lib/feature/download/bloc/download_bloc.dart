import 'dart:convert';
import 'dart:io'; // For file operations
import 'package:application/core/routes/routes.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart'; // For file picker// For directory path

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  DownloadBloc() : super(DownloadInitial()) {
    // Handle fetching biometric units
    on<FetchBiometricUnitsEvent>((event, emit) async {
      try {
        emit(DownloadLoadingState());
        var box = await Hive.openBox("authtoken");
        var userId = box.get("user_id");
        box.close();
        var jsonResponse = await http.post(
          Uri.parse(HttpRoutes.fetchMachines),
          body: jsonEncode(
            {
              "user_id": userId,
            },
          ),
        );
        var response = jsonDecode(jsonResponse.body);
        if (jsonResponse.statusCode == 200) {
          List<String> data = [];
          for (int i = 0; i < response['data'].length; i++) {
            data.add(response['data'][i]['unit_id']);
          }
          emit(FetchBiometricUnitsSuccessState(data: data));
          return;
        }
        emit(FetchBiometricUnitsFailedState(message: response['message']));
      } catch (e) {
        emit(
          FetchBiometricUnitsFailedState(
            message: e.toString(),
          ),
        );
      }
    });

    on<DownloadExcelEvent>((event, emit) async {
      try {
        emit(DownloadLoadingState());
        var box = await Hive.openBox('authtoken');
        var userId = box.get('user_id');
        box.close();
        print(event.startDate);
        print(event.unitId);
        print(userId);
        var response = await http.post(Uri.parse(HttpRoutes.downloadExcel) , body: jsonEncode({
          "start_date": event.startDate,
          "end_date": event.endDate,
          "unit_id": event.unitId,
          "user_id": userId,
        }));

        if (response.statusCode == 200) {
          String? savePath = await _getSavePath();
          if (savePath == null) {
            emit(DownloadExcelFailedState(message: "Save location not selected"));
            return;
          }
          File file = File(savePath);
          await file.writeAsBytes(response.bodyBytes);

          emit(DownloadExcelSuccessState(message: "File downloaded and saved successfully"));
        } else {
          emit(DownloadExcelFailedState(message: "Failed to download the file"));
        }
      } catch (e) {
        emit(DownloadExcelFailedState(message: e.toString()));
      }
    });
  }
  Future<String?> _getSavePath() async {
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory == null) {
        return null;
      }
      String filePath = '$selectedDirectory/Attendance.xlsx';
      return filePath;
    } catch (e) {
      return null;
    }
  }
}

