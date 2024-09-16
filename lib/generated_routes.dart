import 'package:application/feature/auth/bloc/auth_bloc.dart';
import 'package:application/feature/home/bloc/home_bloc.dart';
import 'package:application/feature/home/pages/home_page.dart';
import 'package:application/feature/auth/pages/login_page.dart';
import 'package:application/feature/register/bloc/register_bloc.dart';
import 'package:application/feature/register/pages/register_student_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Routes {
  static Route? onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case "/login":
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AuthBloc(),
            child: const LoginPage(),
          ),
        );
        case "/home":
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => HomeBloc(),
            child: const HomePage(),
          ),
        );
        case "/register":
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => RegisterBloc(),
            child: const RegisterPage(),
          ),
        );
    }
    return null;
  }
}