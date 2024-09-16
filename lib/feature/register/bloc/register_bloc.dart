import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterStudentEvent>((event, emit) {
        try {
          // if(event.studentName.isEmpty || event.studentUSN.isEmpty || event.studentDepartment.isEmpty || event.studentUnitId.isEmpty){
          //   emit(RegisterFailureState(err: "Please Enter Valid Credentials"));
          // }
          List<String> availablePorts = SerialPort.availablePorts;
          print(availablePorts);

        } catch (e) {
          print(e);
        }
    });
  }
}
