import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:application/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<FetchFingerprintMachinesEvent>((event , emit) async {
      try {
        emit(RegisterLoadingState());
        var box = await Hive.openBox('authtoken');
        String userID = box.get('user_id');
        final jsonResponse = await http.post(Uri.parse(HttpRoutes.fetchMachines) , body: jsonEncode({"user_id": userID}));
        final response = jsonDecode(jsonResponse.body);
        if(jsonResponse.statusCode == 200 && response['data'] != null){
            List<String> data = [];
            for(int i = 0 ; i < response['data'].length ; i++){
              data.add(response['data'][i]['unit_id']);
            }
            emit(FetchFingerprintMachineSuccessState(data: data));
            return;
        }
        emit(FetchFingerprintMachineFailureState(errorMessage: response['message']));
      } catch (e) {
        emit(FetchFingerprintMachineFailureState(errorMessage: "Something went wrong..."));
      }
    });


    on<FetchStudentUnitIdEvent>((event , emit) async {
      try{
          emit(RegisterLoadingState());
          final jsonResponse = await http.post(Uri.parse(HttpRoutes.fetchStudents) , body: jsonEncode({"unit_id": event.unitId}));
          final response = jsonDecode(jsonResponse.body);
          if(jsonResponse.statusCode == 200){
              List<String> generated = List.generate(257, (i) => "$i");
              generated.remove("0");
              if(response['data'] == null){
                  emit(FetchStudentUnitIdSuccessState(data: generated));
                  return;
              }
              for(var i in response['data']){
                String existing = i['student_unit_id'];
                generated.remove(existing);
              }
              emit(FetchStudentUnitIdSuccessState(data: generated));
              return;
          }
          emit(FetchStudentUnitIdFailureState(errorMessage: response['message']));
      }catch(e){
        emit(FetchStudentUnitIdFailureState(errorMessage: "Something went wrong..."));
      }
    });


    on<FetchFingerprintMachinePortEvent>((event , emit) async {
        try {
          emit(RegisterLoadingState());
          List<String> ports = SerialPort.availablePorts;
          if(ports.isEmpty){
              emit(FetchFingerprintMachinePortFailureState(errorMessage: "No Ports Found..."));
              return;
          }
          emit(FetchFingerprintMachinePortSuccessState(data: ports));
        } catch (e) {
          emit(FetchFingerprintMachinePortFailureState(errorMessage: "Something went wrong..."));
        }
    });

    on<VerifyDetailsEvent>((event , emit) async {
      try {
          emit(RegisterLoadingState());
          if(event.port.isEmpty || event.studentDepartment.isEmpty || event.studentName.isEmpty || event.studentUSN.isEmpty || event.studentUnitId.isEmpty || event.unitID.isEmpty){
              emit(VerifyDetailsFailureState(errorMessage: "Enter all the field Values"));
              return;
          }
          emit(VerifyDetailsSuccessState());
      } catch (e) {
        emit(VerifyDetailsFailureState(errorMessage: "Something went wrong..."));
      }
    });

    on<RegisterStudentEvent>((event , emit) async {
        try {
            emit(RegisterLoadingState());
            final port = SerialPort(event.port);
            if(!port.openReadWrite()){
                emit(RegisterStudentFailureState(errorMessage: "Unable to open port..."));
                return;
            }
            final reader = SerialPortReader(port);
            final complete = Completer<void>();
            var fingerprintdata = "";

            var config = port.config;
            config.baudRate = 115200;
            config.bits = 8;
            config.stopBits = 1;
            config.parity = 0;
            port.config = config;

             emit(RegisterStudentAccnoledgementState(message: "Place your finger on the Sensor...", status: 0 , animationValue: 0.0));
            await sendControlCommand(port, 0);
            String jsonMessage = "";


            reader.stream.listen((data) async {


              
                  
                  String rawString = String.fromCharCodes(data);
                  // print("raw string : $rawString");
                  RegExp exp = RegExp(r'[{}[\]"0-9,:#a-zA-Z_ ]');
                  String filterString = rawString.split('').where((char) => exp.hasMatch(char)).join('');
                  jsonMessage+=filterString;

              if(jsonMessage.endsWith('#')){
                    var mes = jsonMessage.split('#')[0];
                    var response = jsonDecode(mes);
                    print(response);
                      try {
                      
                        if(response['error_status'] == "0"){
                            switch(response['message_type']){
                                case '0':
                                    emit(RegisterStudentAccnoledgementState(message: "Place your finger on the Sensor...", status: 0 , animationValue: 0.12));
                                    await sendControlCommand(port, 1);
                                    // sleep(const Duration(seconds: 2));
                                    break;
                                case '1':
                                    emit(RegisterStudentAccnoledgementState(message: "Place your finger on the Sensor Again...", status: 0, animationValue: 0.23));
                                    await sendControlCommand(port, 2);
                                    // sleep(const Duration(seconds: 2));
                                    break;
                                case '2':
                                    emit(RegisterStudentAccnoledgementState(message: "Fingerprint Read Success...", status: 1, animationValue: 1));
                                    await sendControlCommand(port, 3);
                                    // sleep(const Duration(seconds: 2));
                                    break;
                                case '3':
                                    fingerprintdata = response['fingerprint_data'];
                                    complete.complete();
                                    emit(RegisterStudentAccnoledgementState(message: "Fingerprint Read Success...", status: 1, animationValue: 1));
                            }
                        } if(response['error_status'] == '1'){
                              emit(RegisterStudentAccnoledgementState(message: "Fingerprint Sensor error please wait...", status: 0, animationValue: 0));
                              // sleep(const Duration(seconds: 2));
                              await sendControlCommand(port, 0);
                        }
                      } catch (e) {
                        print(e.toString());
                              emit(RegisterStudentAccnoledgementState(message: "Fingerprint Sensor error please wait...", status: 0, animationValue: 0));
                              // sleep(const Duration(seconds: 2));
                              sendControlCommand(port, 0);
                      }
                      jsonMessage = "";
                }
            
            });
            await complete.future;
            if(port.isOpen){
              port.flush();
              port.close();
            }
            final jsonResponse = await http.post(
                  Uri.parse(HttpRoutes.registerStudent),
                  body: jsonEncode({
                    "student_unit_id": event.studentUnitId,
                    "unit_id": event.unitID,
                    "student_name": event.studentName,
                    "student_usn": event.studentUSN,
                    "department": event.studentDepartment,
                    "fingerprint_data": fingerprintdata,
          }),
        );
        final response = jsonDecode(jsonResponse.body);
        if(jsonResponse.statusCode == 200){
            emit(RegisterStudentSuccessState());
            return;
        }
        emit(RegisterStudentFailureState(errorMessage: response['message']));
        } catch (e) {
          emit(RegisterStudentFailureState(errorMessage: "Something went wrong..."));
        }
    });
}
  Future<void> sendControlCommand(SerialPort port, int status) async {
    final command = jsonEncode({"control_status": status});
    port.write(Uint8List.fromList(utf8.encode("$command#")));
  }
}

