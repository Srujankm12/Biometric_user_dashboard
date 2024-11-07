import 'dart:convert';

import 'package:application/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginEvent>((event, emit) async {
      try {
        emit(AuthLoadingState());
        if (event.username.isEmpty && event.password.isEmpty) {
          emit(AuthErrorState(error: "Username and Password is required"));
          return;
        }
        var box = await Hive.openBox("authtoken");
        var jsonBody = {
          "user_name": event.username,
          "password": event.password,
        };
        var jsonResponse = await http.post(Uri.parse(HttpRoutes.login),
            body: jsonEncode(jsonBody));
        var response = jsonDecode(jsonResponse.body);
        if (jsonResponse.statusCode == 200) {
          box.put("token", response["data"]);
          final Map<String, dynamic> data = JwtDecoder.decode(response["data"]);
          box.put("user_id", data["id"]);
          box.put("user_name", data["user_name"]);
          box.close();
          emit(AuthSuccessState());
          return;
        }
        emit(AuthErrorState(error: response["message"]));
      } catch (e) {
        emit(AuthErrorState(error: "Something Went Wrong Try Again..."));
      }
    });
  }
}
