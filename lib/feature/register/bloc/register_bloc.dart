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
          List<String> studentUnitID = [];
          int same = 0;
          for(int i = 0 ; i < response['data'].length ; i++){
            for(int j = 0 ; j <= 256 ; j++){
              if(int.parse(response['data'][i]['student_unit_id']) == j){
                same = j;
                break;
              }
            }
            if(same == 0){
              studentUnitID.add(response['data'][i]['student_unit_id']);
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
    on<RegisterStudentEvent>((event , emit) async {
      try{
        emit(RegisterLoadingState());
        var port = SerialPort(event.port);
        String fingerprintData = "";
        if(!port.openReadWrite()){
          emit(RegisterFailureState(err: "Unable to open port..."));
          return;
        }
        final reader = SerialPortReader(port);
        reader.stream.listen((data){
          fingerprintData = utf8.decode(data);
        });
        var jsonReponse = await http.post(Uri.parse(HttpRoutes.registerStudent),body: jsonEncode(
          {
            "student_unit_id": event.studentUnitId,
            "unit_id": event.unitID,
            "student_name": event.studentName,
            "student_usn": event.studentUSN,
            "department": event.studentDepartment,
            "fingerprint": fingerprintData,
          }
        ));
        var response = jsonDecode(jsonReponse.body);
        if(jsonReponse.statusCode == 200){
          emit(RegisterSuccessState(message: response['message']));
          return;
        }
        emit(RegisterFailureState(err: response['message']));
      }catch(e){
        emit(RegisterFailureState(err: e.toString()));
      }
    });
  }
}
