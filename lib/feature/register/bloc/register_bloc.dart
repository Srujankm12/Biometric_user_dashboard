import 'dart:convert';

import 'package:application/core/routes/routes.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<FetchMachinesEvent>((event, emit) async {
      try {
        emit(RegisterLoadingState());
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
          emit(FetchMachinesSuccessState(data: response['data']));
          return;
        }
        emit(RegisterFailureState(err: response['message']));
      } catch (e) {
        emit(RegisterFailureState(err: e.toString()));
      }
    });
    on<FetchStudentUnitIdEvent>((event, emit) async {
      try {
        emit(RegisterLoadingState());
        var jsonResponse = await http.post(Uri.parse(HttpRoutes.fetchStudents) , body: jsonEncode({
          "unit_id": event.unitID,
        },),);
        var response = jsonDecode(jsonResponse.body);
        if(jsonResponse.statusCode == 200){
          List<int> studentUnitID = [];
          int same = 0;
          for(int i = 0 ; i < response['data'].length ; i++){
            for(int j = 0 ; j <= 256 ; j++){
              if(int.parse(response['data'][i]['student_unit_id']) == j){
                same = j;
                break;
              }
            }
            if(same == 0){
              studentUnitID.add(int.parse(response['data'][i]['student_unit_id']));
              same = 0;
            }
            same = 0;
          }
          emit(FetchStudentUnitIdSuccessState(data: studentUnitID)); 
          return;
        }
        emit(RegisterFailureState(err: response['message']));
      } catch (e) {
        emit(RegisterFailureState(err: e.toString()));
      }
    });
    on<FetchComPortsEvent>((event , emit) async {
      try {
        List<String> serialPorts = SerialPort.availablePorts;
        if(serialPorts.isEmpty){
          emit(RegisterFailureState(err: "No Ports Found..."));
        }
        emit(FetchAllPortsSuccessState(data: serialPorts));
      } catch (e) {
        emit(RegisterFailureState(err: e.toString()));
      }
    });
  }
}
