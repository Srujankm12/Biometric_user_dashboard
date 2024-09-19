import 'dart:convert';

import 'package:application/core/routes/routes.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  DetailsBloc() : super(DetailsInitial()) {
    on<FetchAllStudentDetailsEvent>((event, emit) async {
      try {
        var jsonResponse = await http.post(
          Uri.parse(HttpRoutes.fetchStudents),
          body: jsonEncode(
            {
              "unit_id": event.unitId,
            },
          ),
        ); 
        var response = jsonDecode(jsonResponse.body);
        if(jsonResponse.statusCode == 200){
          emit(FetchAllStudentSuccessState(data: response['data']));
          return;
        }
        emit(FetchAllStudentFailureState(message:  response['message']));
      } catch (e) {
        emit(FetchAllStudentFailureState(message: e.toString()));
      }
    });

    on<DeleteStudentEvent>((event , emit) async {
      try {
        emit(DeleteLoadingState());
          var jsonResponse = await http.post(Uri.parse(HttpRoutes.deleteStudent) , body: jsonEncode({
            "student_id": event.studentId,
            "student_unit_id": event.studentUnitId,
            "unit_id": event.unitId,
          },),);
          var response = jsonDecode(jsonResponse.body);
          if(jsonResponse.statusCode == 200){
            emit(DeleteStudentSuccessState(message: response['message']));
            return;
          }
          emit(DeleteStudentFailedState(error: response['message']));
      } catch (e) {
        emit(DeleteStudentFailedState(error: e.toString()));
      }
    });
    on<UpdateStudentEvent>((event , emit) async {
      try {
        emit(UpdateLoadingState());
        var jsonResponse = await http.post(Uri.parse(HttpRoutes.updateStudent) , body: jsonEncode({
            "student_name": event.name,
            "student_usn": event.usn,
            "department": event.branch,
            "unit_id": event.unit,
            "student_id": event.studentID
          },),);
          var response = jsonDecode(jsonResponse.body);
          if(jsonResponse.statusCode == 200){
            emit(UpdateStudentSuccessState(message: response['message']));
            return;
          }
          emit(UpdateStudentFailedState(error: response['message']));
      } catch (e) {
        emit(UpdateStudentFailedState(error: e.toString()));
      }
    });
  }
}
