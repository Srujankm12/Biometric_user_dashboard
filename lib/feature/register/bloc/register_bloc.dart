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
    on<FetchMachinesEvent>((event, emit) async {
      try {
        emit(RegisterLoadingState());
        var box = await Hive.openBox("authtoken");
        var userId = box.get("user_id");
        box.close();
        var jsonResponse = await http.post(
          Uri.parse(HttpRoutes.fetchMachines),
          body: jsonEncode({"user_id": userId}),
        );
        var response = jsonDecode(jsonResponse.body);
        if (jsonResponse.statusCode == 200) {
          List<String> unitId = [];
          for (int i = 0; i < response['data'].length; i++) {
            unitId.add(response['data'][i]['unit_id']);
          }
          emit(FetchMachinesSuccessState(data: unitId));
          return;
        }
        emit(RegisterFailureState(err: response['message']));
      } catch (e) {
        emit(RegisterFailureState(err: "Something Went Wrong Try Again..."));
      }
    });

    on<FetchStudentUnitIdEvent>((event, emit) async {
      try {
        emit(RegisterLoadingState());
        var jsonResponse = await http.post(
          Uri.parse(HttpRoutes.fetchStudents),
          body: jsonEncode({"unit_id": event.unitID}),
        );
        var response = jsonDecode(jsonResponse.body);
        if (jsonResponse.statusCode == 200) {
          Set<int> allNumbers = Set<int>.from(List.generate(257, (i) => i));
          for (var item in response['data']) {
            int id = int.parse(item['student_unit_id']);
            allNumbers.remove(id);
          }
          List<String> studentUnitID =
              allNumbers.map((id) => id.toString()).toList();
          emit(FetchStudentUnitIdSuccessState(data: studentUnitID));
          return;
        }
        emit(RegisterFailureState(err: response['message']));
      } catch (e) {
        emit(RegisterFailureState(err: "Something Went Wrong Try Again..."));
      }
    });

    on<FetchComPortsEvent>((event, emit) async {
      try {
        emit(RegisterLoadingState());
        List<String> serialPorts = SerialPort.availablePorts;
        if (serialPorts.isEmpty) {
          emit(RegisterFailureState(err: "No Ports Found..."));
        }
        emit(FetchAllPortsSuccessState(data: serialPorts));
      } catch (e) {
        emit(RegisterFailureState(err: "Something Went Wrong Try Again..."));
      }
    });

    on<ComPortSelectEvent>((event , emit) {
      if(event.studentBranch.isEmpty || event.studentName.isEmpty || event.studentUsn.isEmpty){
          emit(RegisterFailureState(err: "Please Enter The Form Fields..."));
          return;
      }
        emit(ComPortSelectedState());
    });

    on<RegisterStudentEvent>((event, emit) async {
      try {
        emit(RegisterLoadingState());

        final port = SerialPort(event.port);

        if (!port.openReadWrite()) {
          emit(RegisterFailureState(err: "Unable to open port..."));
          return;
        }

        final reader = SerialPortReader(port);
        String fingerprintData = "";
        final completer = Completer<void>();

        var config = port.config;
        config.baudRate = 115200;
        config.bits = 8;
        config.parity = 0;
        config.stopBits = 1;
        port.config = config;

        sendControlCommand(port, 0);

        // Buffer to accumulate incoming data
        StringBuffer buffer = StringBuffer();

        reader.stream.listen((data) async {
          // Append received data chunk to the buffer
          buffer.write(utf8.decode(data));

          // Check if the buffer contains a complete message (assumed to end with a newline '\n')
          if (buffer.toString().contains('\n')) {
            var messages = buffer
                .toString()
                .split('\n'); // Split on newline to handle multiple messages

            for (var message in messages) {
              if (message.isNotEmpty) {
                try {
                  var response = jsonDecode(message.trim());

                  print(response);

                  if (response['error_status'] == '0') {
                    switch (response['message_type']) {
                      case '0':
                        emit(RegisterAcknowledgmentState( message: "First fingerprint successfully read.", fingerprintstatus: 0.12,),);
                        await sendControlCommand(port, 1);
                        break;
                      case '1':
                        emit(RegisterAcknowledgmentState( message: "Second fingerprint successfully read.", fingerprintstatus: 0.5,),);
                        await sendControlCommand(port, 2);
                        break;
                      case '2':
                        emit(RegisterAcknowledgmentState( message: "Fingerprint data saved successfully.", fingerprintstatus: 1,),);
                        await sendControlCommand(port, 3);
                        break;
                      case '3':
                        fingerprintData = response['fingerprint_data'];
                        completer.complete();
                        port.close();
                        emit(RegisterAcknowledgmentState(message:"Fingerprint data successfully retrieved.",fingerprintstatus: 3,),);
                        break;
                    }
                  } else if (response['error_status'] == '1') {
                    // Handle errors based on error_type
                    switch (response['error_type']) {
                      case '0':
                        emit(RegisterAcknowledgmentState(message: "finger print sensor error", fingerprintstatus: 2));
                        port.close();
                        break;
                      case '1':
                        emit(RegisterAcknowledgmentState(message: "finger print sensor error", fingerprintstatus: 2));
                        port.close();
                        break;
                      case '2':
                        emit(RegisterAcknowledgmentState(message: "finger print sensor error", fingerprintstatus: 2));
                        port.close();
                        break;
                      case '4':
                        emit(RegisterAcknowledgmentState(message: "finger print sensor error", fingerprintstatus: 2));
                        port.close();
                        break;
                      case '5':
                        emit(RegisterAcknowledgmentState(message: "finger print sensor error", fingerprintstatus: 2));
                        port.close();
                        break;
                      case '6':
                        emit(RegisterAcknowledgmentState(message: "finger print sensor error", fingerprintstatus: 2));
                        port.close();
                        break;
                      case '3':
                        emit(RegisterAcknowledgmentState(message: "finger print sensor error", fingerprintstatus: 2));
                        port.close();
                        break;
                      default: 
                        emit(RegisterAcknowledgmentState(message: "finger print sensor error", fingerprintstatus: 2));
                        port.close();
                        break;
                    }
                  }
                } catch (e) {
                  emit(RegisterAcknowledgmentState(message: "finger print sensor error", fingerprintstatus: 2,),);
                  port.close();
                }
              }
            }
            // Clear the buffer after processing the message
            buffer.clear();
          }
        });
        await completer.future;

        // Send the collected fingerprint data to the server
        final jsonResponse = await http.post(
          Uri.parse(HttpRoutes.registerStudent),
          body: jsonEncode({
            "student_unit_id": event.studentUnitId,
            "unit_id": event.unitID,
            "student_name": event.studentName,
            "student_usn": event.studentUSN,
            "department": event.studentDepartment,
            "fingerprint_data": fingerprintData,
          }),
        );

        final response = jsonDecode(jsonResponse.body);

        if (jsonResponse.statusCode == 200) {
          emit(RegisterSuccessState(message: response['message']));
        } else {
          emit(RegisterFailureState(err: response['message']));
        }
      } catch (e) {
        emit(RegisterFailureState(err: "Something Went Wrong Try Again..."));
      }
    });
  }
  Future<void> sendControlCommand(SerialPort port, int status) async {
    final command = jsonEncode({"control_status": status});
    port.write(Uint8List.fromList(utf8.encode(command)));
  }
}
