import 'dart:async';
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
    on<RegisterStudentEvent>((event, emit) async {
      try {
        emit(RegisterLoadingState());
        final port = SerialPort(event.port);

        if (!port.openRead()) {
          print("NOOOOOOOO");
          emit(RegisterFailureState(err: "Unable to open port..."));
          return;
        }
        final reader = SerialPortReader(port);
        String fingerprintData = "";
        final completer = Completer<void>();
                  print("here");
        reader.stream.listen((data) {
                  print("here");
          fingerprintData = utf8.decode(data);
          print("running...");
          completer.complete();
        }, onError: (error) {
          completer.completeError(error);
        });
        await completer.future;
        port.close();
        print("complete...");
        final jsonResponse = await http.post(
          Uri.parse(HttpRoutes.registerStudent),
          body: jsonEncode({
            "student_unit_id": event.studentUnitId,
            "unit_id": event.unitID,
            "student_name": event.studentName,
            "student_usn": event.studentUSN,
            "department": event.studentDepartment,
            "fingerprint": fingerprintData,
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
}
