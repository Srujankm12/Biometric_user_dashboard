
import 'dart:convert';

import 'package:application/core/routes/routes.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'logs_event.dart';
part 'logs_state.dart';

class LogsBloc extends Bloc<LogsEvent, LogsState> {
  LogsBloc() : super(LogsInitial()) {
    on<FetchStudentLogs>((event, emit) async {
      try {
        emit(FetchStudentLogsLoadingState());
        var jsonResponse = await http.post(Uri.parse(HttpRoutes.fetchStudentLogs) , body: jsonEncode({
          "student_id": event.studentID,
        }));
        var response = jsonDecode(jsonResponse.body);
        print(response);
        if(jsonResponse.statusCode == 200){
             emit(FetchStudentLogsSuccessState(data: response['data']));
             return;
        }
        emit(FetchStudentLogsFailedState(error: response['message']));
      } catch (e) {
        emit(FetchStudentLogsFailedState(error: "Something Went Wrong Try Again..."));
      }
    });
  }
}
