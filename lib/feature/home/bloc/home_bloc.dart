import 'dart:convert';

import 'package:application/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;


part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeFetchMachinesEvent>((event, emit) async {
        try {
          emit(HomeMachinesLoadingState());
          var box = await Hive.openBox("authtoken");
          var userId = box.get("user_id");
          box.close();
          print(userId);
          var jsonResponse = await http.post(Uri.parse(HttpRoutes.fetchMachines) , body: jsonEncode({
            "user_id": userId,
          }));
          var response = jsonDecode(jsonResponse.body);
          print(response);
          if(jsonResponse.statusCode == 200) {
            emit(HomeMachinesFetchSuccessState(getMachines: response["data"]));
            return;
          }
          emit(HomeMachinesFetchFailureState(err: "Failed to fetch data try again..."));
        } catch (e) {
          print(e);
          emit(HomeMachinesFetchFailureState(err: "An exception occured while fetching the data try again..."));
        }

    });
  }
}
