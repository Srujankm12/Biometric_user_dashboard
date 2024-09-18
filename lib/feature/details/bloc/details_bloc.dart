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
        print(response);
        if(jsonResponse.statusCode == 200){
          emit(FetchAllStudentSuccessState(data: response['data']));
          return;
        }
        emit(FetchAllStudentFailureState(message:  response['message']));
      } catch (e) {
        emit(FetchAllStudentFailureState(message: e.toString()));
      }
    });
  }
}
