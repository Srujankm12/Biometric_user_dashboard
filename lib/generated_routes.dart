import 'package:application/feature/auth/bloc/auth_bloc.dart';
import 'package:application/feature/auth/pages/login_page.dart';
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
    }
    return null;
  }
}